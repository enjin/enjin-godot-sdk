extends Panel
export(Array, NodePath) var btns: Array

var _btns_disabled: bool = false

func disable_btns():
    _btns_disabled = true
    for i in range(0, btns.size()):
        var btn: Button = get_node(btns[i])
        btn.disabled = true
        btn.focus_mode = Control.FOCUS_NONE

func enable_btns():
    _btns_disabled = false
    for i in range(0, btns.size()):
        var btn: Button = get_node(btns[i])
        btn.disabled = false
        btn.focus_mode = Control.FOCUS_ALL

func btns_disabled() -> bool:
    return _btns_disabled
