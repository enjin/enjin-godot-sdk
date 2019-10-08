extends Thread
class_name EnjinHttp

var url: String

func _init(var builder: Builder):
    url = builder.url

static func builder() -> Builder:
    return Builder.new()

class Builder:

    var url: String setget with_url

    func with_url(var url_in: String) -> Builder:
        url = url_in
        return self