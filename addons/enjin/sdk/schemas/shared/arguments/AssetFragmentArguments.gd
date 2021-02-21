extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"

const EnjinGraphqlRequest = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd")

func _init(owner_in: EnjinGraphqlRequest).(owner_in):
    pass

func asset_id_format(asset_id_format: String) -> EnjinGraphqlRequest:
    return set_variable("assetIdFormat", asset_id_format)

func with_state_data() -> EnjinGraphqlRequest:
    return set_variable("withStateData", true)

func with_config_data() -> EnjinGraphqlRequest:
    return set_variable("withConfigData", true)

func with_asset_blocks() -> EnjinGraphqlRequest:
    return set_variable("withAssetBlocks", true)

func with_creator() -> EnjinGraphqlRequest:
    return set_variable("withCreator", true)

func with_melt_details() -> EnjinGraphqlRequest:
    return set_variable("withMeltDetails", true)

func with_metadata_uri() -> EnjinGraphqlRequest:
    return set_variable("withMetadataURI", true)

func with_supply_details() -> EnjinGraphqlRequest:
    return set_variable("withSupplyDetails", true)

func with_transfer_settings() -> EnjinGraphqlRequest:
    return set_variable("withTransferSettings", true)

func with_asset_variant_mode() -> EnjinGraphqlRequest:
    return set_variable("withAssetVariantMode", true)

func with_asset_variants() -> EnjinGraphqlRequest:
    return set_variable("withAssetVariants", true)

func with_variant_metadata() -> EnjinGraphqlRequest:
    return set_variable("withVariantMetadata", true)