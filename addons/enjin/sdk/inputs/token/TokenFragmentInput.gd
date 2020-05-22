class TokenFragmentInput extends "../BaseInput.gd":
    func _init(vars_in: Dictionary).(vars_in):
        pass

    func id_format(tokenIdFormat: String) -> TokenFragmentInput:
        vars.tokenIdFormat = tokenIdFormat
        return self

    func replace_uri_params(replaceUriParams: bool) -> TokenFragmentInput:
        vars.replaceUriParams = replaceUriParams
        return self

    func with_index(withTokenIndex: bool) -> TokenFragmentInput:
        vars.withTokenIndex = withTokenIndex
        return self

    func with_creator(withCreator: bool) -> TokenFragmentInput:
        vars.withCreator = withCreator
        return self

    func with_blocks(withTokenBlocks: bool) -> TokenFragmentInput:
        vars.withTokenBlocks = withTokenBlocks
        return self

    func with_icon(withTokenIcon: bool) -> TokenFragmentInput:
        vars.withTokenIcon = withTokenIcon
        return self

    func with_melt_details(withMeltDetails: bool) -> TokenFragmentInput:
        vars.withMeltDetails = withMeltDetails
        return self

    func with_delete_status(withDeleteStatus: bool) -> TokenFragmentInput:
        vars.withDeleteStatus = withDeleteStatus
        return self

    func with_supply_details(withSupplyDetails: bool) -> TokenFragmentInput:
        vars.withSupplyDetails = withSupplyDetails
        return self

    func with_transfer_fee_settings(withTransferFeeSettings: bool) -> TokenFragmentInput:
        vars.withTransferFeeSettings = withTransferFeeSettings
        return self

    func with_item_uri(withItemUri: bool) -> TokenFragmentInput:
        vars.withItemUri = withItemUri
        return self

    func with_timestamps(withTokenTimestamps: bool) -> TokenFragmentInput:
        vars.withTokenTimestamps = withTokenTimestamps
        return self
