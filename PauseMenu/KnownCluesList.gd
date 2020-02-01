extends Node2D

func get_pause_menu():
    return get_parent()

func get_room():
    return get_pause_menu().get_room()

func on_push() -> void:
    visible = true

func on_pop() -> void:
    visible = false

func _ready() -> void:
    visible = false

func _process(_delta: float) -> void:
    pass

func handle_input(input_type: String) -> bool:
    match input_type:
        "ui_down", "ui_up", "ui_accept":
            pass
        "ui_cancel":
            get_pause_menu().pop_control()
    return true # Modal
