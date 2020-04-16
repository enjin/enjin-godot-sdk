extends Reference

const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")
# Statuses
const STATUS_CONNECTION_FAILED = "Unable to establish connection to host."
# HTTP Status Groups
var CONNECTING_STATUSES = [HTTPClient.STATUS_RESOLVING, HTTPClient.STATUS_CONNECTING]
var ERROR_STATUSES = [HTTPClient.STATUS_CANT_RESOLVE, HTTPClient.STATUS_CANT_CONNECT, HTTPClient.STATUS_CONNECTION_ERROR, HTTPClient.STATUS_SSL_HANDSHAKE_ERROR]

var _base_url: String
var _port: int
var _use_ssl: bool
var _verify_host: bool
var _thread: Thread
var _sem: Semaphore
var _mutex: Mutex
var _quit_thread: bool = false
var _connection_pool_size
var _connection_pool_count = 0
var _connection_pool = []
var _request_queue = []

func _init(base_url: String, port: int = 443, use_ssl: bool = true, verify_host: bool = true, connection_pool_size: int = 10):
    _base_url = base_url
    _port = port
    _use_ssl = use_ssl
    _verify_host = verify_host
    _connection_pool_size = connection_pool_size
    _thread = Thread.new()
    _sem = Semaphore.new()
    _mutex = Mutex.new()
    _thread.start(self, "_run")

func enqueue(call: EnjinCall, callback: EnjinCallback, udata: Dictionary = {}):
    _mutex.lock()
    _request_queue.push_back([null, call, callback, null, udata])
    _mutex.unlock()
    _sem.post()

func _run(userdata):
    while !_quit_thread:
        _sem.wait()
        while _request_queue.size() > 0:
            _process_queue()
        OS.delay_msec(100)

func _process_queue():
    for idx in range(_request_queue.size()):
        var req = _request_queue[idx]

        # Acquire http client instance
        if req[0] == null:
            if _connection_pool.empty():
                if _is_pool_full():
                    continue
                else:
                    _create_client()
                    req[0] = _connection_pool.pop_back()
            else:
                req[0] = _connection_pool.pop_back()
                _connect_client(req[0])

        _process_request(idx, req)

func _process_request(idx: int, req: Array):
    var client: HTTPClient = req[0]
    var status = client.get_status()

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
            _complete_request(idx, req)
            return
        # Initiate the request
        var call: EnjinCall = req[1]
        client.request(call.get_method(), call.get_endpoint(), call.get_headers(), call.get_body())
        client.poll()
    elif status in ERROR_STATUSES:
        _complete_request(idx, req)
    else:
        client.poll()

func _complete_request(idx: int, req: Array):
    # Remove request from request queue
    _mutex.lock()
    _request_queue.remove(idx)
    _mutex.unlock()

    var client: HTTPClient = req[0]
    var call: EnjinCall = req[1]
    var callback = req[2]
    var response = req[3]
    var udata: Dictionary = req[4]
    # Get response code and headers
    var code = client.get_response_code()
    var headers = client.get_response_headers_as_dictionary()
    # Return the client to the connection pool
    _reclaim_client(req)
    # Get the response body string
    var body
    if response == null:
        body = "failed"
    else:
        body = response.get_string_from_ascii()
    udata.response = EnjinResponse.new(call, code, headers, body)
    # Call the request callback on the main thread
    if callback != null:
        callback.complete_deffered_1(udata)

func _is_pool_full() -> bool:
    return _connection_pool_count >= _connection_pool_size

func _create_client():
    var client: HTTPClient = HTTPClient.new()
    var result: bool = _connect_client(client)
    if !result:
        print(STATUS_CONNECTION_FAILED)
        return
    _connection_pool.push_back(client)
    _connection_pool_count += 1

func _connect_client(client: HTTPClient) -> bool:
    if client.get_status() == HTTPClient.STATUS_CONNECTED:
        return true

    var result = client.connect_to_host(_base_url, _port, _use_ssl, _verify_host)
    if result != OK:
        return false

    while client.get_status() in CONNECTING_STATUSES:
        client.poll()

    return client.get_status() == HTTPClient.STATUS_CONNECTED

func _reclaim_client(req: Array):
    var client: HTTPClient = req[0]
    client.close()
    req[0] = null
    _connection_pool.push_back(client)
