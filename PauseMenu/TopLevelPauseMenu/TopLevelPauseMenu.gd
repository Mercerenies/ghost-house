extends Node2D

signal option_selected(option)

var _options: Array = []
var _option: int = 0

func _update_self():
    $SelectionsList.update()
    call_deferred("_update_text") # Need to give the label a frame to update itself.

func _update_text():
    var height = $SelectionsList.get_text_rect().size.y

    $Frame.polygon[2].y = $Frame.polygon[1].y + height + 8
    $Frame.polygon[3].y = $Frame.polygon[0].y + height + 8

# Each entry should be a dictionary containing an integer "id" field
# and a string "text" field.
func set_options(options: Array) -> void:
    $SelectionsList.set_options(options)
    _update_self()

func get_chosen_option() -> Dictionary:
    return $SelectionsList.get_selected_option()

func on_push() -> void:
    _update_self()
    $SelectionsList.set_selected_option_index(0)

func on_pop() -> void:
    pass

func _ready() -> void:
    _update_self()

func handle_input(input_type: String) -> bool:
    match input_type:
        "ui_down":
            $SelectionsList.cursor_down()
        "ui_up":
            $SelectionsList.cursor_up()
        "ui_accept":
            emit_signal("option_selected", get_chosen_option()["id"])
        "ui_cancel":
            get_parent().unpause()
    return true # Modal
