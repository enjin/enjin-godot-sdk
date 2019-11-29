extends "res://addons/gut/test.gd"

var directory = Directory.new()
var inputs_dir = "res://addons/enjin/sdk/inputs/"

const EnjinGraphqlSchema = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlSchema.gd")

#onready var constants = EnjinGraphqlSchema.get_script_constant_map()
var constants: Dictionary
var _schema: EnjinGraphqlSchema

var class_methods : Array
var class_method_names = []

var FragmentDB: Dictionary
var QueryDB: Dictionary

class CustomArraySorter:
    static func sort_by_encounters(a_pair, b_pair):
        if a_pair[1] > b_pair[1]:
            return true
        return false


func before_all():
    _schema = EnjinGraphqlSchema.new()
    QueryDB = _schema.get_operation_registry()
    
    for key in QueryDB.keys():
        var query_name = QueryDB[key]
        
        if _schema.has_template(query_name):
            var template = _schema.get_template(query_name)
            var arguments = template.get_arguments()
            print(arguments)
    
    class_methods = BaseInput.get_script_method_list()
    for method in class_methods:
        class_method_names.append(method.name)


    
    _schema = EnjinGraphqlSchema.new()
    QueryDB = _schema.get_operation_registry()
    
    for key in QueryDB.keys():
        if _schema.has_template(key):
            print("======= " + key + " ========")
            var template = _schema.get_template(key)
            var arguments = template.get_arguments()
            var compiled = template.get_compiled_template()
            constants[key] = compiled

func before_each():
    pass

func after_each():
    pass

func after_all():
    pass

#This unit test is supposed to test every input for correct assignments that match the schema.
#It can detect incorrect dictionary keys that either do not match with the schema or are missing.
func test_Inputs_setget():
    if directory.dir_exists(inputs_dir):
        directory.change_dir(inputs_dir)
        
    if(!directory.list_dir_begin()):
        while true:
            var file = directory.get_next()
            if directory.current_is_dir():
                continue
            if file == "":
                break
            var file_path = inputs_dir + file
            print("===== " + file_path + " =====")
            var input_script = load(file_path)
            var script_methods = input_script.get_script_method_list()
            
            var constant_counter = {}
            var map_func_to_var = {}
            
            for script_method in script_methods:
                if script_method.name in class_method_names:
                    continue
                
                print("[*] " + script_method.name)
                var return_type = script_method.get("return")
                var func_name = script_method.get("name")
                var func_args = script_method.get("args")
                
                #Omit from automatic testing
                var arg_type = func_args[0].type
                if arg_type == TYPE_OBJECT:
                    continue
            
                #Find assignment key used to extract the actual input name
                var input_script_instance = input_script.new()
                
                var dummy_arg = null
                if arg_type == TYPE_INT:
                    dummy_arg = 1
                if arg_type == TYPE_BOOL:
                    dummy_arg = true
                if arg_type == TYPE_STRING:
                    dummy_arg = "str"
                if arg_type == TYPE_ARRAY:
                    dummy_arg = []
                input_script_instance.call(func_name, dummy_arg)
                var var_name = input_script_instance.input.keys()[0]
                map_func_to_var[func_name] = var_name
                
                assert_eq(input_script_instance.create().get(var_name), dummy_arg, "Assignment not successful")
                
                #Find variable inside constants
                var input_found = false
                var found_constants = []
            
                for key in constants.keys():
                    if key.ends_with("_FRAGMENT") or key.ends_with("_ARGS"):
                        continue
                    var constant = constants[key]
                    if constant.find("$"+var_name) != -1:
                        input_found = true
                        found_constants.append(key)
                        if constant_counter.has(key):
                            constant_counter[key] += 1
                        else:
                            constant_counter[key] = 1
            
        
            #Find constant schema with most var encounters
            if constant_counter.size() == 0:
                continue
            
            var constants_keys = constant_counter.keys()
            #Convert to pairs
            var sorted_constants = []
            for constant_key in constants_keys:
                var pair = [constant_key, constant_counter[constant_key]]
                sorted_constants.append(pair)
                
            sorted_constants.sort_custom(CustomArraySorter, "sort_by_encounters")
            var constant_name = sorted_constants[0][0]
            print("Constant: " + constant_name)
            
            #Attempt to find remaining variables
            var constant_data = constants[constant_name]
            var not_found_func_names = []
            
            for script_method in script_methods:
                if script_method.name in class_method_names:
                    continue
                var return_type = script_method.get("return")
                var func_name = script_method.get("name")
                var func_args = script_method.get("args")
                
                #Omit from automatic testing
                var arg_type = func_args[0].type
                if arg_type == TYPE_OBJECT:
                    continue
                
                var var_name = map_func_to_var[func_name]
            
                if constant_data.find("$" + var_name) == -1:
                    not_found_func_names.append(func_name)
            
            for not_found_func_name in not_found_func_names:
                assert_eq(true, false, "Function "+not_found_func_name+"() not found or does not set a proper variable name")
            
        directory.list_dir_end()

func test_GetUserInput_pagination():
    var get_user_input = GetUserInput.new()
    var dummy_param = PaginationInput.new()
    get_user_input.pagination(dummy_param)
    var var_name = get_user_input.input.keys()[0]
    var left = get_user_input.create().get(var_name)
    assert_eq(left, dummy_param.create(), "Assignment not successful")
    
