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

func get_pause_menu():
    return get_parent()

func _update_self():
    $SelectionsList.update()
    call_deferred("_update_text") # Need to give the label a frame to update itself.

func _update_text():
    var height = $SelectionsList.get_text_rect().size.y

    $Frame.polygon[2].y = $Frame.polygon[1].y + height + 8
    $Frame.polygon[3].y = $Frame.polygon[0].y + height + 8

func get_chosen_option() -> Dictionary:
    return $SelectionsList.get_selected_option()

func on_push() -> void:
    visible = true
    _update_self()
    $SelectionsList.set_selected_option_index(0)

func on_pop() -> void:
    visible = false

func _ready() -> void:
    visible = false
    $SelectionsList.set_options(_options)
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
