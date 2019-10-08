extends Node
class_name EnjinHttp

# Statuses
const STATUS_CONNECTION_FAILED = "Unable to establish connection to host."

var url: String
var thread: Thread
var quit_thread: bool = false

func _init(url_in: String):
    url = url_in
    thread = Thread.new()
    thread.start(self, "run")

func run(userdata):
    while !quit_thread:
#        if http.get_status() == HTTPClient.STATUS_DISCONNECTED:
#            var result = http.connect_to_host(url, 443, true, true)
#            if result != OK:
#                print(STATUS_CONNECTION_FAILED)
#
#            while http.get_status() == HTTPClient.STATUS_RESOLVING || http.get_status() == HTTPClient.STATUS_CONNECTING:
#                http.poll()
#
#            if http.get_status() != HTTPClient.STATUS_CONNECTED:
#                print(STATUS_CONNECTION_FAILED)
#
#        if http.get_status() != HTTPClient.STATUS_CONNECTED:
#            print(http.get_status())

        OS.delay_msec(100)

func enqueue(call: EnjinCall, callback: EnjinCallback):
    pass