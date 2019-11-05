extends UserFragmentInput
class_name DeleteUserInput

func id(id: int) -> DeleteUserInput:
    input.id = id
    return self