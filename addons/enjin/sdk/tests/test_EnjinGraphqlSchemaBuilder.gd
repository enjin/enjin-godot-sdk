extends "res://addons/gut/test.gd"

const EnjinGraphqlQueryBuilder = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlQueryBuilder.gd")

var gql_builder: EnjinGraphqlQueryBuilder.GQLBuilder


func before_all():
    gql_builder = EnjinGraphqlQueryBuilder.GQLBuilder.new()

    gql_builder.UseFolder("res://addons/enjin/sdk/graphql/templates/")

func before_each():
    pass

func after_each():
    pass

func after_all():
    pass

func test_EnjinGraphqlQueryBuilder_queries():
    var QueryDB = gql_builder.GetQueryDB()
    
    for query_name in QueryDB.keys():
        var query_template = gql_builder.ReadQL(QueryDB[query_name].GetPath(), null)
        #print(query_template.GetBody() % query_template.ListArguments(",\n"))
        
        #todo: validate gql syntax?

func test_EnjinGraphqlQueryBuilder_mutations():
    var MutationDB = gql_builder.GetMutationDB()
    
    for mutation_name in MutationDB.keys():
        var mutation_template = gql_builder.ReadQL(MutationDB[mutation_name].GetPath(), null)
        #print(mutation_template.GetBody() % mutation_template.ListArguments(",\n"))
        
        #todo: validate gql syntax?
