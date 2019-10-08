extends Node
class_name TrustedPlatformClient

# URLs
const KOVAN_BASE = "kovan.cloud.enjin.io"
# Statuses
const STATUS_CONNECTION_FAILED = "Unable to establish connection to host."

var url: String
var http: HTTPClient
var thread: Thread
var quit_thread: bool = false

func _init(var base_url: String = KOVAN_BASE):
    url = base_url
    http = HTTPClient.new();
    thread = Thread.new();
    thread.start(self, "run_thread")

# TODO: refactor to EnjinHttp
func run_thread(data):
    while !quit_thread:
        if http.get_status() == HTTPClient.STATUS_DISCONNECTED:
            var result = http.connect_to_host(url, 443, true, true)
            if result != OK:
                print(STATUS_CONNECTION_FAILED)

            while http.get_status() == HTTPClient.STATUS_RESOLVING || http.get_status() == HTTPClient.STATUS_CONNECTING:
                http.poll()

            if http.get_status() != HTTPClient.STATUS_CONNECTED:
                print(STATUS_CONNECTION_FAILED)

        if http.get_status() != HTTPClient.STATUS_CONNECTED:
            print(http.get_status())

        OS.delay_msec(100)

func login_user(var email: String, var password: String):
    var body = to_json_body(EnjinOauth.login_user_query(email, password))
    var result = http.request(HTTPClient.METHOD_POST, "/graphql", [], body)
    assert(result == OK)

func to_json_body(var query: String):
    return to_json({"query": query})