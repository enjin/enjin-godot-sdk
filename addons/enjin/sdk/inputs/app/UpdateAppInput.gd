extends "./BaseAppInput.gd"
class_name UpdateAppInput

func id(id: int) -> UpdateAppInput:
    vars.id = id
    return self

func name(name: String) -> UpdateAppInput:
    vars.name = name
    return self

func description(description: String) -> UpdateAppInput:
    vars.description = description
    return self

func image(image: String) -> UpdateAppInput:
    vars.image = image
    return self
