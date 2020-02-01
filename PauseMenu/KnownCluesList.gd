extends Node2D

const KnownClueEntry = preload("KnownClueEntry.tscn")

func get_pause_menu():
    return get_parent()

func get_room():
    return get_pause_menu().get_room()

func on_push() -> void:
    visible = true
    var ghost_database = get_room().get_ghost_database()
    var known_clues = ghost_database.get_known_clues()
    if len(known_clues) == 0:
        $NoCluesLabel.visible = true
    else:
        $NoCluesLabel.visible = false
        var y = 0
        for key in known_clues:
            var clue = ghost_database.get_clue_by_id(key)
            var info = ghost_database.get_info_by_id(key)
            var entry = KnownClueEntry.instance()
            entry.position = Vector2(0, y)
            entry.fill_in_data(clue, info)
            y += entry.TOTAL_HEIGHT
            $CluesList.add_child(entry)

func on_pop() -> void:
    visible = false
    for c in $CluesList.get_children():
        c.queue_free()

func _ready() -> void:
    visible = false

func handle_input(input_type: String) -> bool:
    match input_type:
        "ui_down", "ui_up", "ui_accept":
            pass
        "ui_cancel":
            get_pause_menu().pop_control()
    return true # Modal
