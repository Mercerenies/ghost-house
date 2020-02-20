extends Node2D

signal option_selected(option)

var item: ItemInstance = null

func get_pause_menu():
    return get_parent().get_pause_menu()

func _ready() -> void:
    visible = false

func _expand_item_action(id: int) -> Dictionary:
    var data = item.get_item()
    return { "id": id, "text": item.action_name(data) }

func set_item(item: ItemInstance) -> void:
    self.item = item
    var data = item.get_item()
    $Sprite.frame = data.get_icon_index()
    $NameLabel.set_text(data.get_name())
    $DescLabel.set_text(data.get_description())

    # /////
    #var actions = data.get_actions()
    #actions = Util.map(self, "_expand_item_action", actions)

    $SelectionsList.set_options([{ "id": 0, "text": "Example 0" }, { "id": 1, "text": "Example 1" }])

func get_chosen_option() -> Dictionary:
    return $SelectionsList.get_selected_option()

func on_push() -> void:
    visible = true

func on_pop() -> void:
    visible = false

func handle_input(input_type: String) -> bool:
    match input_type:
        "ui_up":
            $SelectionsList.cursor_up()
        "ui_down":
            $SelectionsList.cursor_down()
        "ui_accept":
            emit_signal("option_selected", get_chosen_option()["id"])
        "ui_cancel":
            get_pause_menu().pop_control()
    return true # Modal

func _on_ItemPanel_option_selected(option: int):
    print(option) # /////
