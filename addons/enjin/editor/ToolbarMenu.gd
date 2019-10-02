tool # required for the script to execute in the editor
extends MenuButton

func _ready():
    populate()

func populate():
    get_popup().add_item("Info")
    get_popup().connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(id):
    print("item pressed: " + String(id))