extends Node2D

const GhostNamer = preload("res://GhostNamer/GhostNamer.gd")

# TODO Show the clue visually here as well
var _clue: Dictionary
var _info: GhostInfo

var _image_index: int

func get_pause_menu():
    return get_parent().get_pause_menu()

func _update_self() -> void:
    $Sprite.texture = GhostNamer.gender_to_image(_info.gender)
    var gender_text = GhostNamer.gender_to_string(_info.gender)
    $Label.set_text("Name: {}\nGender: {}".format([_info.ghost_name, gender_text], "{}"))

func fill_in_data(clue: Dictionary, info: GhostInfo) -> void:
    _clue = clue
    _info = info
    _update_self()

func on_push() -> void:
    visible = true

func on_pop() -> void:
    visible = false

func _process(_delta: float) -> void:
    $Sprite.frame = 4 + _image_index # 4 = 4 * FACING_DOWNWARD

func handle_input(input_type: String) -> bool:
    match input_type:
        "ui_down", "ui_up", "ui_accept":
            pass
        "ui_cancel":
            get_pause_menu().pop_control()
    return true # Modal

func _on_SpriteAnimationTimer_timeout() -> void:
    _image_index = (_image_index + 1) % 4
