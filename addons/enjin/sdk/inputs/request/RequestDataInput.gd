class RequestDataInput extends "./BaseRequestInput.gd":
    func create_token(data: Dictionary) -> RequestDataInput:
        vars.createTokenData = data
        return self

    func create_trade(data: Dictionary) -> RequestDataInput:
        vars.createTradeData = data
        return self

    func complete_trade(data: Dictionary) -> RequestDataInput:
        vars.completeTradeData = data
        return self

    func mint(data: Dictionary) -> RequestDataInput:
        vars.mintTokenData = data
        return self

    func melt(data: Dictionary) -> RequestDataInput:
        vars.meltTokenData = data
        return self

    func send_token(data: Dictionary) -> RequestDataInput:
        vars.sendTokenData = data
        return self

    func send_enj(data: Dictionary) -> RequestDataInput:
        vars.sendEnjData = data
        return self

    func advanced_send(data: Dictionary) -> RequestDataInput:
        vars.advancedSendTokenData = data
        return self

    func update_item_name(data: Dictionary) -> RequestDataInput:
        vars.updateItemNameData = data
        return self

    func set_item_uri(data: Dictionary) -> RequestDataInput:
        vars.setItemUriData = data
        return self

    func set_whitelisted(data: Dictionary) -> RequestDataInput:
        vars.setWhitelistedData = data
        return self

    func approve_enj(data: Dictionary) -> RequestDataInput:
        vars.approveEnjData = data
        return self

    func approve_item(data: Dictionary) -> RequestDataInput:
        vars.approveItemData = data
        return self

    func set_transferable(data: Dictionary) -> RequestDataInput:
        vars.setTransferableData = data
        return self

    func set_melt_fee(data: Dictionary) -> RequestDataInput:
        vars.setMeltFeeData = data
        return self

    func decrease_max_melt_fee(data: Dictionary) -> RequestDataInput:
        vars.decreaseMaxMeltFeeData = data
        return self

    func set_transfer_fee(data: Dictionary) -> RequestDataInput:
        vars.setTransferFeeData = data
        return self

    func decrease_max_transfer_fee(data: Dictionary) -> RequestDataInput:
        vars.decreaseMaxTransferFeeData = data
        return self

    func release_reserve(data: Dictionary) -> RequestDataInput:
        vars.releaseReserveData = data
        return self

    func add_log(data: Dictionary) -> RequestDataInput:
        vars.addLogData = data
        return self

    func batch_approve(data: Dictionary) -> RequestDataInput:
        vars.batchApproveData = data
        return self

    func set_approval(data: Dictionary) -> RequestDataInput:
        vars.setApprovalData = data
        return self

    func set_approval_for_all(data: Dictionary) -> RequestDataInput:
        vars.setApprovalForAllData = data
        return self

    func message(data: Dictionary) -> RequestDataInput:
        vars.messageData = data
        return self
