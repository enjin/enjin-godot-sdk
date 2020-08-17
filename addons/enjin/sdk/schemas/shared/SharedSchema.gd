extends "res://addons/enjin/sdk/schemas/BaseSchema.gd"

func _init(middleware: TrustedPlatformMiddleware, schema: String).(middleware, schema):
    pass

func advanced_send_token(request: AdvancedSendToken,
                         callback: EnjinCallback,
                         udata: Dictionary):
    pass

func approve_enj(request: ApproveEnj,
                 callback: EnjinCallback,
                 udata: Dictionary):
    pass

func approve_max_enj(request: ApproveMaxEnj,
                     callback: EnjinCallback,
                     udata: Dictionary):
    pass

func complete_trade(request: CompleteTrade,
                    callback: EnjinCallback,
                    udata: Dictionary):
    pass

func create_trade(request: CreateTrade,
                  callback: EnjinCallback,
                  udata: Dictionary):
    pass

func get_balances(request: GetBalances,
                  callback: EnjinCallback,
                  udata: Dictionary):
    pass

func get_gas_prices(request: GetGasPrices,
                    callback: EnjinCallback,
                    udata: Dictionary):
    pass


func get_platform(request: GetPlatform,
                  callback: EnjinCallback,
                  udata: Dictionary):
    pass

func get_project(request: GetProject,
                 callback: EnjinCallback,
                 udata: Dictionary):
    pass

func get_request(request: GetRequest,
                 callback: EnjinCallback,
                 udata: Dictionary):
    pass

func get_requests(request: GetRequests,
                  callback: EnjinCallback,
                  udata: Dictionary):
    pass

func get_token(request: GetToken,
               callback: EnjinCallback,
               udata: Dictionary):
    pass

func get_tokens(request: GetBalances,
                callback: EnjinCallback,
                udata: Dictionary):
    pass

func melt_token(request: MeltToken,
                callback: EnjinCallback,
                udata: Dictionary):
    pass

func message(request: Message,
             callback: EnjinCallback,
             udata: Dictionary):
    pass

func reset_enj_approval(request: ResetEnjApproval,
                        callback: EnjinCallback,
                        udata: Dictionary):
    pass

func send_enj(request: SendEnj,
              callback: EnjinCallback,
              udata: Dictionary):
    pass

func send_token(request: SendToken,
                callback: EnjinCallback,
                udata: Dictionary):
    pass

func set_approval_for_all(request: SetApprovalForAll,
                          callback: EnjinCallback,
                          udata: Dictionary):
    pass
