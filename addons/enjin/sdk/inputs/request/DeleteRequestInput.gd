extends "./BaseRequestInput.gd"
class_name DeleteRequestInput

func id(id: int) -> DeleteRequestInput:
    vars.id = id
    return self
