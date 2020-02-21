extends Node2D

signal option_selected(option)

var item: ItemInstance = null

func get_pause_menu():
    return get_parent().get_pause_menu()

func get_room():
    return get_pause_menu().get_room()

func _ready() -> void:
    visible = false

func _expand_item_action(id: int) -> Dictionary:
    var data = item.get_item()
    return { "id": id, "text": data.action_name(id) }

func _add_default_actions(actions: Array) -> void:
    actions.insert(0, Item.ACTION_CANCEL)

func set_item(item: ItemInstance) -> void:
    self.item = item
    var data = item.get_item()
    $Sprite.frame = data.get_icon_index()
    $NameLabel.set_text(data.get_name())
    $DescLabel.set_text(data.get_description())

    var actions = data.get_actions()
    _add_default_actions(actions)
    actions = Util.map(self, "_expand_item_action", actions)

    $SelectionsList.set_options(actions)

func get_chosen_option() -> Dictionary:
    return $SelectionsList.get_selected_option()

func on_push() -> void:
    visible = true
    $SelectionsList.set_selected_option_index(0)

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

func _on_ItemPanel_option_selected(option: int) -> void:
    # First, see if we can handle it here
    match option:
        Item.ACTION_CANCEL:
            get_pause_menu().pop_control()
        _:
            # If not, delegate to the item
            item.get_item().do_action(get_room(), item, option)
            get_pause_menu().pop_control()
            get_parent().refresh_data(false)
