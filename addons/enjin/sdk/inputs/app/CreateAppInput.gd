extends "./BaseAppInput.gd"
class_name CreateAppInput

func name(name: String) -> CreateAppInput:
    vars.name = name
    return self

func description(description: String) -> CreateAppInput:
    vars.description = description
    return self

func image(image: String) -> CreateAppInput:
    vars.image = image
    return self
