extends Node2D

# DEBUG CODE Obviously

signal option_selected(option)

enum Option {
    UnlockAllClues = 0,
    RevealMinimap = 1,
    FullyHealPlayer = 2,
}

onready var _options: Array = [
    { "id": Option.UnlockAllClues, "text": "Unlock All Clues" },
    { "id": Option.RevealMinimap, "text": "Reveal Minimap" },
    { "id": Option.FullyHealPlayer, "text": "Fully Heal Player" },
]
var _option: int = 0

func get_pause_menu():
    return get_parent()

func _update_self():
    $Label.text = ""
    for opt in _options:
        $Label.text += opt["text"] + '\n'
    call_deferred("_update_text") # Need to give the label a frame to update itself.

func _update_text():

    var height0 = ($Label.get_line_height()) * ($Label.get_line_count() - 1)
    $Label.rect_size.y = height0 - 4
    var line_height = $Label.rect_size.y / (len(_options) + 1)
    var height = $Label.rect_size.y

    $Frame.polygon[2].y = $Frame.polygon[1].y + height + 8
    $Frame.polygon[3].y = $Frame.polygon[0].y + height + 8

    $CurrentOption.position = $Label.rect_position + Vector2(-16, $Label.get_line_height() / 2)
    $CurrentOption.position.y += line_height * _option

# Each entry should be a dictionary containing an integer "id" field
# and a string "text" field.
func set_options(options: Array) -> void:
    _options = options
    _update_self()

func get_chosen_option() -> Dictionary:
    return _options[_option]

func on_push() -> void:
    visible = true
    _option = 0
    _update_self()

func on_pop() -> void:
    visible = false

func _ready() -> void:
    visible = false
    _update_self()

func handle_input(input_type: String) -> bool:
    match input_type:
        "ui_down":
            _option += 1
            _option = (_option % len(_options) + len(_options)) % len(_options)
            _update_self()
        "ui_up":
            _option -= 1
            _option = (_option % len(_options) + len(_options)) % len(_options)
            _update_self()
        "ui_accept":
            emit_signal("option_selected", get_chosen_option()["id"])
        "ui_cancel":
            get_pause_menu().pop_control()
    return true # Modal

func _on_DebugMenu_option_selected(option: int):
    match option:
        Option.UnlockAllClues:
            var room = get_pause_menu().get_room()
            var ghost_database = room.get_ghost_database()
            for key in ghost_database.get_ghost_keys():
                ghost_database.meet_ghost(key)
            get_pause_menu().unpause()
        Option.RevealMinimap:
            var room = get_pause_menu().get_room()
            var minimap = room.get_minimap()
            for key in minimap.room_ids():
                minimap.discover_room(key)
            get_pause_menu().unpause()
        Option.FullyHealPlayer:
            var room = get_pause_menu().get_room()
            var stats = room.get_player_stats()
            stats.set_player_health( stats.get_player_max_health() )
            get_pause_menu().unpause()
