extends "res://addons/gut/test.gd"

const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")

var enjin_call = null
var enjin_callback_1 = null
var enjin_callback_2 = null
var enjin_callback_3 = null

var doubled_class_instance = null

func before_all():
    var DoubledResponse = double(preload("res://addons/enjin/sdk/tests/double_response.gd"))
    doubled_class_instance = DoubledResponse.new()
    
    enjin_call = EnjinCall.new()

func before_each():
    pass

func after_each():
    pass

func after_all():
    doubled_class_instance.free()

func test_EnjinCall_setget():
    assert_accessors(enjin_call, 'method', HTTPClient.METHOD_GET, HTTPClient.METHOD_POST)
    assert_accessors(enjin_call, 'endpoint', "", "test_string")
    assert_accessors(enjin_call, 'body', "", "test_string")

func test_EnjinCall_set_content_type():
    var content_type = "my_content_type"
    enjin_call.set_content_type(content_type)
    
    var found_content_type = false
    
    for header in enjin_call.get_headers():
        if header.begins_with("Content-Type") and header.ends_with(content_type):
            found_content_type = true
    
    assert_eq(found_content_type, true, "Content-Type could not be set")
