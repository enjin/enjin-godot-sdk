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

### Fetching A Player

There are a variety of ways to get a player. See below for examples:

```gdscript
var _client: TrustedPlatformClient
var _get_player_cb: EnjinCallback

func _init():
    _client = TrustedPlatformClient.new()
    _create_player_cb = EnjinCallback.new(self, "_get_player")

func get_current_user():
    var input = GetUserInput.new().me(true)
    _client.user_service().get_user(input, { "callback": _get_player_cb})

func get_user_with_name(name: String):
    var input = GetUserInput.new().name(name)
    _client.user_service.get_user(input, { "callback": _get_player_cb})

func get_user_with_id(id: int):
    var input = GetUserInput.new().id(id)
    _client.user_service.get_user(input, { "callback": _get_player_cb})
```

`get_current_user()` demonstrates how to get the current authenticated player in your game client. `get_user_with_name(String)` and `get_user_with_id(int)` on the other hand are an ideal way to get a specific player server-side.

You can also get multiple users using `_client.user_service().get_users(GetUsersInput, Dictionary)`. When getting multiple users the result will be paginated, so it may require multiple requests to fetch all results depending on the size of the result set.

### Fetching And Linking Player Identity

##### Fetching Identities

```gdscript
var _client: TrustedPlatformClient
var _get_player_cb: EnjinCallback

func _init():
    _client = TrustedPlatformClient.new()
    _create_player_cb = EnjinCallback.new(self, "_get_player")

func get_current_user():
    var input = GetUserInput.new().me(true)
    input.user_i.with_identities(true)
    input.identity_i.with_linking_code(true)
    input.identity_i.with_linking_code_qr(true)
    input.identity_i.with_wallet(true)
    _client.user_service().get_user(input, { "callback": _get_player_cb})

func _get_player(udata: Dictionary):
    var gql: EnjinGraphqlResponse = udata.gql
    if gql.has_errors():
        return
    # The result type is dependent on the query. For singular result queries it will be a Dictionary usually.
    # For query's with multiple results it will be an Array.
    var user: Dictionary = gql.get_result()
    # Get the user's identities.
    var identities: Array = user.identities
    # Verify the user has identities.
    if identities.size() == 0:
        return
    # Player accounts are (as of writing) unique the app they are created for, so get the first identity.
    var identity: Dictionary = identities[0]
    # The linking codes (if linked) may be null.
    var linking_code: String = identity.linkingCode
    var linking_code_qr: String = identity.linkingCodeQr
    # The wallet (if not linked) may be null.
    var wallet: Dictionary = identity.wallet
    var eth_addr: String = wallet.ethAddress

```

In the above example we are telling GraphQL to include the identities and their linking codes and wallet address. SDK inputs, due to limitations of GDScript, often have embedded inputs for the various fragments utilized in the queries. These fragment inputs have additional variables that can be set much like with the top-level input. In the case of the example we are setting variables in the identity fragment input, telling it to include the linking text and qr code, and the wallet (which will only include the address by default).

We start by getting the result `var user: Dictionary = gql.get_result()`. Depending on the query this may be an array if it is capable of returning multiple results (e.g. get_users). Because we requested that the identities be included we first get the identities: `var identities: Array = user.identities` and then get the first identity (if it exists) `var identity: Dictionary = identities[0]`. At the time of writing, when creating a new user it creates a user unique to the app, thus there should only be one identity associated with that user. Now that we have the identity, we can access the text code: `var linking_code: String = identity.linkingCode`, qr code url: `var linking__code_qr: String = identity.linkingCodeQr`, and wallet: `var wallet: Dictionary = identity.wallet`. When an identity is linked the wallet will exist, otherwise it will be null. If the wallet does exist we can get the linked address: `var eth_addr: String = wallet.ethAddress`.

##### Linking Wallet

If an identity is not linked to a wallet you will need to send them the linking code and/or display the qr code so that they can link their wallet to the identity from inside the Enjin Wallet android/iOS app. An example of how to display the QR code to a player can be found in `PlatformClient.gd` of the demo project.

### Fetching Player Balances

While it is possible to fetch balances when getting a player's identities, it is recommended to use the wallet service to fetch balances of the linked Ethereum address.

```gdscript
var _client: TrustedPlatformClient
var _get_wallet_cb: EnjinCallback

func _init():
    _client = TrustedPlatformClient.new()
    _get_wallet_cb = EnjinCallback.new(self, "_get_wallet")

func get_wallet(eth_addr: String):
    var input = GetWalletInput.new().eth_addr(eth_addr)
    input.wallet_i.with_balances(true)
    _client.wallet_service().get_wallet(input, { "callback": _get_wallet_cb})

func _get_wallet(udata: Dictionary):
    var gql: EnjinGraphqlResponse = udata.gql
    if gql.has_errors():
        return
    var wallet: Dictionary = gql.get_result()
    var balances: Array = wallet.balances
```

To fetch a player's wallet and balances we create the input `var input = GetWalletInput.new.eth_addr(eth_addr)`, then include the balances `input.wallet_i.with_balances(true)`, and finally submit our request. Once we have the wallet we can get the balances array: `var balances: Array = wallet.balances`. The balances, by default, include the id, index, and value (amount).

### Sending Tokens To Player

```gdscript
var _client: TrustedPlatformClient

func _init():
    _client = TrustedPlatformClient.new()

func send_token(app_id: int, token_id: String, amount: int, sender_id: int, recipient_id: int):
    var input: CreateRequestInput = CreateRequestInput.new()
    input.app_id(app_id)
    input.tx_type("SEND")
    input.identity_id(sender_id)
    input.send_token({
            "token_id": token_id,
            "recipient_identity_id": recipient_id,
            "value": amount
        })

    # Create a new request.
    _tp_client.request_service().create_request(input)
```

The above example demonstrates how to send a token to a player. `input.app_id(app_id)` sets the id of the app (your apps id) that this request is being created for. `input.tx_type("SEND")` sets the type to be a send token request. `input.identity_id(sender_id)` designates the identity to send from. The `input.send_token()` function takes in a dictionary that needs a `token_id`, `recipient_identity_id`, and `value` key set.
