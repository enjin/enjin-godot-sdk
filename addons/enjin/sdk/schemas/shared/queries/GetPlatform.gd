extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetPlatform

func _init().("enjin.sdk.shared.GetPlatform"):
    pass

func with_contracts() -> GetPlatform:
    set_variable("withContracts", true)
    return self

func with_notification_drivers() -> GetPlatform:
    set_variable("withNotificationDrivers", true)
    return self
