extends Node2D

signal option_selected(option)

const OPTION_YES = 0
const OPTION_NO = 1

export(int, "Yes", "No") var default_option = 0
export(String, MULTILINE) var prompt = ""

func get_pause_menu():
    return get_parent().get_pause_menu()

func get_room():
    return get_pause_menu().get_room()

func _ready() -> void:
    visible = false
    $SelectionsList.set_options([{"id": 0, "text": "Yes"}, {"id": 1, "text": "No"}])

func on_push() -> void:
    visible = true
    $SelectionsList.set_selected_option_index(default_option)
    $PromptLabel.text = prompt

func on_pop() -> void:
    visible = false

func handle_input(input_type: String) -> bool:
    match input_type:
        "ui_up":
            $SelectionsList.cursor_up()
        "ui_down":
            $SelectionsList.cursor_down()
        "ui_accept":
            emit_signal("option_selected", $SelectionsList.get_selected_option()["id"])
        "ui_cancel":
            get_pause_menu().pop_control()
    return true # Modal
