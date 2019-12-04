extends "../BaseInput.gd"
class_name GetPlatformInput

func with_block_height(withBlockHeight: bool) -> GetPlatformInput:
    vars.withBlockHeight = withBlockHeight
    return self

func with_contracts(withContracts: bool) -> GetPlatformInput:
    vars.withContracts = withContracts
    return self

func with_notification_drivers(withNotificationDrivers: bool) -> GetPlatformInput:
    vars.withNotificationDrivers = withNotificationDrivers
    return self
