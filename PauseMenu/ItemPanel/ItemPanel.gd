extends Node2D

func get_pause_menu():
    return get_parent().get_pause_menu()

func _ready() -> void:
    visible = false

func set_item(item: ItemInstance) -> void:
    var data = item.get_item()
    $Sprite.frame = data.get_icon_index()
    $NameLabel.set_text(data.get_name())
    $DescLabel.set_text(data.get_description())

func on_push() -> void:
    visible = true

func on_pop() -> void:
    visible = false

func handle_input(input_type: String) -> bool:
    match input_type:
        "ui_cancel":
            get_pause_menu().pop_control()
    return true # Modal
