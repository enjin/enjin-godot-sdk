extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"

const EnjinGraphqlRequest = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd")

func _init(owner_in: EnjinGraphqlRequest).(owner_in):
    pass

func bal_id_format(bal_id_format: String) -> EnjinGraphqlRequest:
    return set_variable("balIdFormat", bal_id_format)

func bal_index_format(bal_index_format: String) -> EnjinGraphqlRequest:
    return set_variable("balIndexFormat", bal_index_format)

func with_bal_project_id() -> EnjinGraphqlRequest:
    return set_variable("withBalProjectId", true)

func with_bal_wallet_address() -> EnjinGraphqlRequest:
    return set_variable("withBalWalletAddress", true)
