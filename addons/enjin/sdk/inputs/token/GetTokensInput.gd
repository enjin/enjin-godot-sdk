extends "./GetTokenInput.gd"
class_name GetTokensInput

const PaginatedInput = preload("res://addons/enjin/sdk/inputs/PaginatedInput.gd").PaginatedInput

var paginated_i: PaginatedInput

func _init():
    paginated_i = PaginatedInput.new(vars)

func name(name: String) -> GetTokensInput:
    vars.name = name
    return self

func creator(creator: String) -> GetTokensInput:
    vars.creator = creator
    return self

func total_supply(totalSupply: String) -> GetTokensInput:
    vars.totalSupply = totalSupply
    return self

func reserve(reserve: String) -> GetTokensInput:
    vars.reserve = reserve
    return self

func supply_model(supplyModel: String) -> GetTokensInput:
    vars.supplyModel = supplyModel
    return self

func melt_value(meltValue: String) -> GetTokensInput:
    vars.meltValue = meltValue
    return self

func melt_fee_ratio(meltFeeRation: String) -> GetTokensInput:
    vars.meltFeeRatio = meltFeeRation
    return self

func non_fungible(nonFungible: bool) -> GetTokensInput:
    vars.nonFungible = nonFungible
    return self

func first_block(firstBlock: int) -> GetTokensInput:
    vars.firstBlock = firstBlock
    return self

func block_height(blockHeight: int) -> GetTokensInput:
    vars.blockHeight = blockHeight
    return self

func marked_for_delete(markedForDelete: bool) -> GetTokensInput:
    vars.markedForDelete = markedForDelete
    return self

func sort(sort: Dictionary) -> GetTokensInput:
    vars.sort = sort
    return self
