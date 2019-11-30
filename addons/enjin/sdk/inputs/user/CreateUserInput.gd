extends BaseInput
class_name CreateUserInput

var user_i: UserFragmentInput
var role_i: RoleFragmentInput
var identity_i: IdentityFragmentInput
var wallet_i: WalletFragmentInput
var balance_i: SimpleBalanceFragmentInput
var token_i: TokenFragmentInput

func _init():
    user_i = UserFragmentInput.new(vars)
    role_i = RoleFragmentInput.new(vars)
    identity_i = IdentityFragmentInput.new(vars)
    wallet_i = WalletFragmentInput.new(vars)
    balance_i = SimpleBalanceFragmentInput.new(vars)
    token_i = TokenFragmentInput.new(vars)

func app_id(appId: int) -> CreateUserInput:
    vars.appId = appId
    return self

func name(name: String) -> CreateUserInput:
    vars.name = name
    return self

func email(email: String) -> CreateUserInput:
    vars.email = email
    return self

func password(password: String) -> CreateUserInput:
    vars.password = password
    return self

func identity_id(identityId: int) -> CreateUserInput:
    vars.identityId = identityId
    return self

func role(role: String) -> CreateUserInput:
    vars.role = role
    return self