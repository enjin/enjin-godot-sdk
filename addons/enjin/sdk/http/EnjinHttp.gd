extends Reference
class_name EnjinHttp

# Statuses
const STATUS_CONNECTION_FAILED = "Unable to establish connection to host."
# HTTP Status Groups
var CONNECTING_STATUSES = [HTTPClient.STATUS_RESOLVING, HTTPClient.STATUS_CONNECTING]
var ERROR_STATUSES = [HTTPClient.STATUS_CANT_RESOLVE, HTTPClient.STATUS_CANT_CONNECT, HTTPClient.STATUS_CONNECTION_ERROR, HTTPClient.STATUS_SSL_HANDSHAKE_ERROR]

var url: String
var thread: Thread
var sem: Semaphore
var mutex: Mutex
var quit_thread: bool = false
var connection_pool_max_size
var connection_pool_count = 0
var connection_pool = []
var request_queue = []

func _init(url_in: String, pool_size: int = 10):
    url = url_in
    connection_pool_max_size = pool_size
    thread = Thread.new()
    sem = Semaphore.new()
    mutex = Mutex.new()
    thread.start(self, "run")

func run(userdata):
    while !quit_thread:
        sem.wait()
        while request_queue.size() > 0:
            process_queue()
        OS.delay_msec(100)

func process_queue():
    for idx in range(request_queue.size()):
        var req = request_queue[idx]

        # Acquire http client instance
        if req[0] == null:
            if connection_pool.empty():
                if is_pool_full():
                    continue
                else:
                    create_client()
                    req[0] = connection_pool.pop_back()
            else:
                req[0] = connection_pool.pop_back()

        process_request(idx, req)

func process_request(idx: int, req: Array):
    var client: HTTPClient = req[0]
    var status = client.get_status()
    print(status)

    if status == HTTPClient.STATUS_BODY:
        client.poll()
        # Create data pool if not set
        if req[3] == null:
            req[3] = PoolByteArray()
        # Read the next response body chunk
        var chunk = client.read_response_body_chunk()
        # Append chunk to data pool
        if chunk.size() > 0:
            req[3] = req[3] + chunk
    elif status == HTTPClient.STATUS_CONNECTED:
        if req[3] != null:
            process_completed_request(idx, req)
            return
        # Initiate the request
        var call: EnjinCall = req[1]
        client.request(call.get_method(), call.get_endpoint(), call.get_headers(), call.get_body())
        client.poll()
    elif status in ERROR_STATUSES:
        process_completed_request(idx, req)
    else:
        client.poll()

func process_completed_request(idx: int, req: Array):
    # Remove request from request queue
    mutex.lock()
    request_queue.remove(idx)
    mutex.unlock()

    var client: HTTPClient = req[0]
    var call: EnjinCall = req[1]
    var callback: EnjinCallback = req[2]
    var response: PoolByteArray = req[3]
    # Get response code and headers
    var code = client.get_response_code()
    var headers = client.get_response_headers_as_dictionary()
    # Return the client to the connection pool
    reclaim(req)
    # Get the response body string
    var body
    if response == null:
        body = "failed"
    else:
        body = response.get_string_from_ascii()
    # Call the request callback on the main thread
    callback.get_instance().call_deferred(callback.get_method(), EnjinResponse.new(call, code, headers, body))

func is_pool_full() -> bool:
    return connection_pool_count >= connection_pool_max_size

func reclaim(req: Array):
    var client: HTTPClient = req[0]
    req[0] = null
    connection_pool.push_back(client)

func create_client():
    var client: HTTPClient = HTTPClient.new()
    var result: bool = connect_client(client)
    if !result:
        print(STATUS_CONNECTION_FAILED)
        return
    connection_pool.push_back(client)
    connection_pool_count += 1

func connect_client(client: HTTPClient) -> bool:
    if client.get_status() == HTTPClient.STATUS_CONNECTED:
        return true

    var result = client.connect_to_host(url, 443, true, true)
    if result != OK:
        return false

    while client.get_status() in CONNECTING_STATUSES:
        client.poll()

    return client.get_status() == HTTPClient.STATUS_CONNECTED


func enqueue(call: EnjinCall, callback: EnjinCallback):
    mutex.lock()
    request_queue.push_back([null, call, callback, null])
    mutex.unlock()
    sem.post()