extends "./RequestDataInput.gd".RequestDataInput
class_name UpdateRequestInput

func id(id: int) -> UpdateRequestInput:
    vars.id = id
    return self

func rebroadcast(rebroadcast: bool) -> UpdateRequestInput:
    vars.rebroadcast = rebroadcast
    return self
