extends "res://addons/enjin/sdk/schemas/BaseSchema.gd"

func _init(middleware: TrustedPlatformMiddleware, schema: String).(middleware, schema):
    pass

func advanced_send_token(request: AdvancedSendToken,
                         callback: EnjinCallback = null,
                         udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func approve_enj(request: ApproveEnj,
                 callback: EnjinCallback = null,
                 udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func approve_max_enj(request: ApproveMaxEnj,
                     callback: EnjinCallback = null,
                     udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func cancel_transaction(request: CancelTransaction,
                        callback: EnjinCallback = null,
                        udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func complete_trade(request: CompleteTrade,
                    callback: EnjinCallback = null,
                    udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func create_trade(request: CreateTrade,
                  callback: EnjinCallback = null,
                  udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func get_balances(request: GetBalances,
                  callback: EnjinCallback = null,
                  udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func get_gas_prices(request: GetGasPrices,
                    callback: EnjinCallback = null,
                    udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)


func get_platform(request: GetPlatform,
                  callback: EnjinCallback = null,
                  udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func get_project(request: GetProject,
                 callback: EnjinCallback = null,
                 udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func get_request(request: GetRequest,
                 callback: EnjinCallback = null,
                 udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func get_requests(request: GetRequests,
                  callback: EnjinCallback = null,
                  udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func get_token(request: GetToken,
               callback: EnjinCallback = null,
               udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func get_tokens(request: GetBalances,
                callback: EnjinCallback = null,
                udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func melt_token(request: MeltToken,
                callback: EnjinCallback = null,
                udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func message(request: Message,
             callback: EnjinCallback = null,
             udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func reset_enj_approval(request: ResetEnjApproval,
                        callback: EnjinCallback = null,
                        udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func send_enj(request: SendEnj,
              callback: EnjinCallback = null,
              udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func send_token(request: SendToken,
                callback: EnjinCallback = null,
                udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func set_approval_for_all(request: SetApprovalForAll,
                          callback: EnjinCallback = null,
                          udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)
