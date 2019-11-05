extends BaseInput
class_name UserFragmentInput

func with_user_roles(withUserRoles: bool) -> UserFragmentInput:
    input.withUserRoles = withUserRoles
    return self

func with_user_identities(withUserIdentities: bool) -> UserFragmentInput:
    input.withUserIdentities = withUserIdentities
    return self

func with_identity_roles(withIdentityRoles: bool) -> UserFragmentInput:
    input.withIdentityRoles = withIdentityRoles
    return self

func with_wallet(withWallet: bool) -> UserFragmentInput:
    input.withWallet = withWallet
    return self

func with_balances(withBalances: bool) -> UserFragmentInput:
    input.withBalances = withBalances
    return self

func with_tokens_created(withTokensCreated: bool) -> UserFragmentInput:
    input.withTokensCreated = withTokensCreated
    return self

func with_timestamps(withTimestamps: bool) -> UserFragmentInput:
    input.withTimestamps = withTimestamps
    return self

func bal_app_id(balAppId: int) -> UserFragmentInput:
    input.balAppId = balAppId
    return self

func bal_token_id(balTokenId: String) -> UserFragmentInput:
    input.balTokenId = balTokenId
    return self

func bal_equal(balVal: int) -> UserFragmentInput:
    input.balVal = balVal
    return self

func bal_greater_than(balGt: int) -> UserFragmentInput:
    input.balGt = balGt
    return self

func bal_greater_than_or_equal(balGte: int) -> UserFragmentInput:
    input.balGte = balGte
    return self

func bal_less_than(balLt: int) -> UserFragmentInput:
    input.balLt = balLt
    return self

func bal_less_than_or_equal(balLte: int) -> UserFragmentInput:
    input.balLte = balLte
    return self

func token_id_format(tokenIdFormat: String) -> UserFragmentInput:
    input.tokenIdFormat = tokenIdFormat
    return self

func token_index_format(tokenIndexFormat: String) -> UserFragmentInput:
    input.tokenIndexFormat = tokenIndexFormat
    return self