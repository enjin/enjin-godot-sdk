# Enjin SDK Demo

The example project demonstrates basic usage of the SDK. Scripts are broken into three categories:

- Server
- Client
- Shared

## Server

The `PlatformServer` script creates a new `TrustedPlatformClient` instance and authenticates with the cloud using the app credentials (the app's id and secret). The server is responsible for creating and authenticating players, and sending tokens to the player. Upon authenticating a token the server recieves a player access token which is then forwarded to the client.

## Client

The `PlatformClient` script communicates with the `PlatformServer` using web sockets to simulate the separation of server and client responsibilities. The client handshakes with the server and in return the server authenticates the player and forwards the player access token. Upon receiving the access token the client authenticates its own instance of `TrustedPlatformClient`. Once authenticated the client fetches the player's user data and facilitates the wallet linking process, showing a QR code if not linked.

You will also find a number of other client scripts for demo mechanic implementations. It should be noted that these are naive implementations and may not follow GDScript best practices. Godot provides documenation, tutorials and an active community you can use as resources for implementing the mechanics of your games.

## Shared

Shared scripts are used by both the server and the client, such as `Settings`, for example. These scripts do not demonstrate any SDK functionality.

# SDK Usage

There are a few things that are important for developers to know in order to use the SDK efficiently. The API is separated into a handful of service classes that have their own set of responsibilities.

### Auth App Example

```gdscript
var _client: TrustedPlatformClient
var _auth_app_cb: EnjinCallback

func _init():
    _client = TrustedPlatformClient.new()
    _auth_app_cb = EnjinCallback.new(self, "_auth_app")

func auth_app(appId: Int, secret: String):
    var auth_service = _client.auth_service()
    auth_service.auth_app(appId, secret, { "callback": _auth_app_cb })

func _auth_app(udata: Dictionary):
    if _client.get_state().is_authed_as_app():
        print("App authentication succeeded!")
    else:
        print("App authentication failed!")
```

The above example demonstrates how to authenticate your client using the app id and secret. Let's go over and break down the code example.

`TrustedPlatformClient.new()` creates a new client with default settings. By default the client will connect to `kovan.cloud.enjin.io` (TestNet cloud platform).

`EnjinCallback.new(self, "_auth_app")` creates a new callback definition. This callback will peform a deferred call to the method `_auth_app` on the instance `self`.

`_client.auth_service()` returns the auth service instance. With this service you can authentication the client as an app or a player.

`auth_service.auth_app(appId, secret, { "callback": _auth_app_cb })` sends an app authentication request to the cloud. This particular function requires the app's id and secret (GraphQL parameters). Service class functions also take a `Dictionary` parameter that will hold a reference to the callback, we will refer to this as `udata` for now. Throughout the lifetime of the request additional context data (such as the call and response) may be added to the udata. While not a required parameter, it is highly recommended to provide a new udata instance with the callback defined when making a request. Since the udata is mutable it is not advised to reuse the same instance. The udata instance you provide will be passed as an argument to the method you defined in the callback. You can also assign additional data to this dictionary. To access the response in the callback do the following: `var response: EnjinGraphqlResponse = udata.gql`. The GraphQL response class holds references to the http response (`EnjinResponse`) and deserialized errors, result, and pagination cursor.

Finally, to the check if the client authenticated successfully you can use `_client.get_state().is_authed_as_app()`. The state (`TrustedPlatformState`) holds a reference to the app id and access token.

### Auth Player Example

It should be noted that player authentication does not utilize emails and passwords and is not a sufficient means to prove a player's authenticity. As such you will need to implement your own form of player database and authentication. Player authentication on the SDK takes place on your servers and requires a unique id associated with your players. Upon authenticating a player you will receive an access token which is to be forwarded to the player so they can authenticate their TrustedPlatformClient instance. This will be demonstrated with two code examples below:

##### Server Example

```gdscript
var _client: TrustedPlatformClient
var _auth_player_cb: EnjinCallback

func _init():
    _client = TrustedPlatformClient.new()
    _auth_player_cb = EnjinCallback.new(self, "_auth_player")

# Requires that _client already be authed as an app.
func auth_player(name: String):
    var auth_service = _client.auth_service()
    auth_service.auth_player(name, { "callback": _auth_player_cb })

func _auth_player(udata: Dictionary):
    var gql = udata.gql
    if gql.has_errors():
        if gql.get_errors()[0].code == 401:
            # Create a new player.
            return
    elif gql.has_result():
        var session = gql.get_result()
        # forward session to client over web socket or other transport protocol.
        return
```

The example above demonstrates how to authenticate a player. This works similarly to the auth app example. The break down is as follows.

`auth_service.auth_player(name, { "callback": _auth_player_cb })` sends a request to the cloud to authenticate the player with the provided name.

`if gql.has_errors():` lets us know if there were any errors encountered due to invalid request parameters. For example, if the user hasn't been created the cloud will return error code 401.

##### Client Example

```gdscript
var _client: TrustedPlatformClient = TrustedPlatformClient.new()

# This would be dependent on how you choose to communicate between the server and client.
# For simplicity sake let's pretend this method receives a byte encoded packet.
func data_received(raw_packet):
    # Decode the received packet
    var packet: Dictionary = bytes2var(raw_packet)
    var session = packet.session
    # Auth the player with the session access token.
    _client.get_state().auth_user(session.accessToken)
```

### Creating A Player

As seen in the example above, if you attempt to authenticate a player that does not exist, you will get response error 401. We can use this error code to determine when we need to create a new player.

```gdscript
var _client: TrustedPlatformClient
var _create_player_cb: EnjinCallback

func _init():
    _client = TrustedPlatformClient.new()
    _create_player_cb = EnjinCallback.new(self, "_create_player")

func create_player(name: String):
    _client.user_service().create_user(name, { "callback": _create_player_cb, "name": name })

func _create_player(udata: Dictionary):
    var gql = udata.gql
    if gql.has_errors():
        return
    elif gql.has_result():
        print("Created User: %s" % udata.name)
```

Above we demonstrate how to create a new player. `_client.user_service().create_user(name, { "callback": _create_player_cb, "name": name})` creates a new user and attaches the provided name to the udata for future reference in the callback.
