extends Reference

const GraphqlArgument = preload("res://addons/enjin/sdk/graphql/GraphqlArgument.gd")
const GraphqlTemplate = preload("res://addons/enjin/sdk/graphql/GraphqlTemplate.gd")

var _sdk_template_path = "res://addons/enjin/sdk/graphql/templates/"
var _fragment_registry: Dictionary setget , get_fragment_registry
var _operation_registry: Dictionary setget , get_operation_registry
var _additional_template_paths: Array

func _init(template_paths: Array = []):
    _additional_template_paths = template_paths
    var templates = _load_templates()
    _fragment_registry = templates.fragments
    _operation_registry = templates.operations
    _compile_templates()

func _load_templates() -> Dictionary:
    var out: Dictionary = {}
    out.fragments = {}
    out.operations = {}
    _load_templates_from_dir(_sdk_template_path, out)
    for path in _additional_template_paths:
        _load_templates_from_dir(path, out)
    return out

func _load_templates_from_dir(path: String, out: Dictionary):
    var dir: Directory = Directory.new()
    var dir_queue: Array = [path]

    while !dir_queue.empty():
        var next_path: String = dir_queue.pop_front()

        if dir.change_dir(next_path) != OK:
            continue
        if dir.list_dir_begin(true, true) != OK:
            continue

        var current_dir: String = dir.get_current_dir()
        var file_name: String = dir.get_next()

        while file_name != "":
            var file_path: String = "%s/%s" % [current_dir, file_name]
            if dir.current_is_dir():
                dir_queue.push_back(file_path + "/")
            else:
                _load_template_from_file(current_dir, file_name, out)
            file_name = dir.get_next()
        dir.list_dir_end()

func _load_template_from_file(folder: String, file_name: String, out: Dictionary):
    var path = "%s/%s" % [folder, file_name]
    var is_fragment: bool = file_name.ends_with("Fragment.gql")
    var is_query: bool = file_name.ends_with("Query.gql")
    var is_mutation: bool = file_name.ends_with("Mutation.gql")
    var file = File.new()

    file.open(path, File.READ)

    if !is_fragment and !is_query and !is_mutation:
        return

    var template_name = file_name.replace(".gql", "")
    var template = GraphqlTemplate.new(path, template_name)

    while not file.eof_reached():
        var line = file.get_line()
        var trimmed_line = line.strip_edges()
        var is_fragment_def: bool = trimmed_line.begins_with("fragment")
        var is_query_def: bool = trimmed_line.begins_with("query")
        var is_mutation_def: bool = trimmed_line.begins_with("mutation")
        var is_argument_def: bool = trimmed_line.begins_with("$")
        var is_fragment_ref: bool = trimmed_line.begins_with("...")

        if is_argument_def:
            _parse_argument_def(trimmed_line, template)
            continue
        if is_fragment_ref:
            template.add_fragment_ref(trimmed_line)

        template.append_line(line + "\n")

    if is_fragment:
        out.fragments[template_name] = template
    elif is_query or is_mutation:
        out.operations[template_name] = template

func _parse_argument_def(line: String, template: GraphqlTemplate):
    var arg: GraphqlArgument = GraphqlArgument.new(line)
    template.add_argument(arg)

func _compile_templates():
    for op_name in _operation_registry.keys():
        var op: GraphqlTemplate = _operation_registry.get(op_name)
        var args: Dictionary = op._arguments.duplicate()
        var processed_frags: Array = []
        var frag_queue: Array = []
        var compiled_op: String = op._raw_template

        _queue_fragments(op, frag_queue, processed_frags)
        while not frag_queue.empty():
            var frag_name: String = frag_queue.pop_front()

            if processed_frags.has(frag_name):
                continue
            if not _fragment_registry.has(frag_name):
                continue

            var frag: GraphqlTemplate = _fragment_registry.get(frag_name)
            _queue_fragments(frag, frag_queue, processed_frags)
            for arg_name in frag._arguments.keys():
                if args.has(arg_name):
                    continue
                args[arg_name] = frag._arguments[arg_name]
            compiled_op += "\n%s" % frag._raw_template
            processed_frags.push_back(frag_name)

        if not args.empty():
            var is_query: bool = compiled_op.begins_with("query")
            var is_mutation: bool = compiled_op.begins_with("mutation")

            if is_query:
                compiled_op = compiled_op.replace("query", "query (\n%s\n)" % _args_to_list(args))
            if is_mutation:
                compiled_op = compiled_op.replace("mutation", "mutation (\n%s\n)" % _args_to_list(args))

        op._compiled_template = compiled_op
        op._is_cached = true

func _queue_fragments(template: GraphqlTemplate, queue: Array, processed: Array):
    for ref in template._fragment_refs:
        if queue.has(ref) or processed.has(ref):
            continue
        queue.push_back(ref)

func _args_to_list(args: Dictionary, separator: String = "\n") -> String:
    var list: String = ""
    for name in args.keys():
        var arg: GraphqlArgument = args.get(name)
        list += arg.to_string() + separator
    return list.rstrip(separator)

func get_fragment_registry() -> Dictionary:
    return _fragment_registry

func get_operation_registry() -> Dictionary:
    return _operation_registry

func get_operation_for_name(name: String) -> GraphqlTemplate:
    return _operation_registry.get(name)

func get_template(template_name) -> GraphqlTemplate:
    var template = null

    if has_template(template_name):
        template = _operation_registry.get(template_name)

    return template

func has_template(template_name) -> bool:
    return _operation_registry.has(template_name)

func build_request_body(template_name: String, variables: Dictionary) -> String:
    var template: GraphqlTemplate = get_template(template_name)

    var request_body = {}
    request_body.query = template.get_compiled_template()
    request_body.variables = variables

    return request_body
