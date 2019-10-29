extends "res://addons/gut/test.gd"

const EnjinCallback = preload("res://addons/enjin/sdk/http/EnjinCallback.gd")

var enjin_callback_0 = null
var enjin_callback_1 = null
var enjin_callback_2 = null
var enjin_callback_3 = null

var doubled_class_instance = null

func before_all():
    var DoubledResponse = double(preload("res://addons/enjin/sdk/tests/double_response.gd"))
    doubled_class_instance = DoubledResponse.new()
    
    enjin_callback_0 = EnjinCallback.new(doubled_class_instance, "_on_callback_0")
    enjin_callback_1 = EnjinCallback.new(doubled_class_instance, "_on_callback_1")
    enjin_callback_2 = EnjinCallback.new(doubled_class_instance, "_on_callback_2")
    enjin_callback_3 = EnjinCallback.new(doubled_class_instance, "_on_callback_3")

func before_each():
    pass

func after_each():
    pass

func after_all():
    doubled_class_instance.free()

func test_EnjinCallback():
    enjin_callback_0.complete_deffered_0()
    enjin_callback_1.complete_deffered_1(true)
    enjin_callback_2.complete_deffered_2(true, true)
    enjin_callback_3.complete_deffered_3(true, true, true)
    
    yield(yield_for(1), YIELD)
    
    assert_call_count(doubled_class_instance, "_on_callback_0", 1)
    assert_call_count(doubled_class_instance, "_on_callback_1", 1)
    assert_call_count(doubled_class_instance, "_on_callback_2", 1)
    assert_call_count(doubled_class_instance, "_on_callback_3", 1)
    
    assert_called(doubled_class_instance, "_on_callback_0", null)
    assert_called(doubled_class_instance, "_on_callback_1", [true])
    assert_called(doubled_class_instance, "_on_callback_2", [true, true])
    assert_called(doubled_class_instance, "_on_callback_3", [true, true, true])

func test_EnjinCallback_setget():
    var test_object = Object()
    
    var enjin_callback = EnjinCallback.new(null, "")
    
    assert_accessors(enjin_callback, 'instance', null, test_object)
    assert_accessors(enjin_callback, 'method', "", "test_string")
