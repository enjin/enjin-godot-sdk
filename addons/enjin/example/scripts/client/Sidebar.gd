extends Panel
export(Array, NodePath) var btns: Array

func disable_btns():
    for i in range(0, btns.size()):
        var btn: Button = get_node(btns[i])
        btn.disabled = true

func enable_btns():
    for i in range(0, btns.size()):
        var btn: Button = get_node(btns[i])
        btn.disabled = false
