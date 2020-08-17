extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetPlatform

func _init().("enjin.sdk.shared.GetPlatform"):
    pass

func with_contracts() -> GetPlatform:
    return set_variable("withContracts", true)

func with_notification_drivers() -> GetPlatform:
    return set_variable("withNotificationDrivers", true)
