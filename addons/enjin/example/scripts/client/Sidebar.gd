extends Panel
export(Array, NodePath) var btns: Array

func disable_btns():
    for i in range(0, btns.size()):
        var btn: Button = get_node(btns[i])
        btn.disabled = true
        btn.focus_mode = Control.FOCUS_NONE

func enable_btns():
    for i in range(0, btns.size()):
        var btn: Button = get_node(btns[i])
        btn.disabled = false
        btn.focus_mode = Control.FOCUS_ALL
