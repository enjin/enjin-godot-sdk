extends "res://addons/gut/test.gd"

const EnjinGraphqlQueryBuilder = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlQueryBuilder.gd")

var gql_builder: EnjinGraphqlQueryBuilder.GQLBuilder


func before_all():
    gql_builder = EnjinGraphqlQueryBuilder.GQLBuilder.new()

    gql_builder.add_folder("res://addons/enjin/sdk/graphql/templates/")

func before_each():
    pass

func after_each():
    pass

func after_all():
    pass

func test_EnjinGraphqlQueryBuilder_queries():
    var QueryDB = gql_builder.get_query_db()
    
    for query_name in QueryDB.keys():
        var query_template = gql_builder.read_ql(QueryDB[query_name].get_path(), null)
        #print(query_template.get_body() % query_template.list_arguments(",\n"))
        
        #todo: validate gql syntax?

func test_EnjinGraphqlQueryBuilder_mutations():
    var MutationDB = gql_builder.get_mutation_db()
    
    for mutation_name in MutationDB.keys():
        var mutation_template = gql_builder.read_ql(MutationDB[mutation_name].get_path(), null)
        #print(mutation_template.get_body() % mutation_template.list_arguments(",\n"))
        
        #todo: validate gql syntax?
