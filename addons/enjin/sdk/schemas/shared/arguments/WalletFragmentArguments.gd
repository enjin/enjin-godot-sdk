extends "res://addons/enjin/sdk/schemas/shared/arguments/BaseArgument.gd"

func _init(owner_in: EnjinGraphqlRequest).(owner_in):
    pass

func with_tokens_created() -> EnjinGraphqlRequest:
    return set_variable("withTokensCreated", true)
