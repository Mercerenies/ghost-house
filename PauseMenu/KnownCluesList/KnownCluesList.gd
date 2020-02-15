extends Node2D

const KnownClueEntryScene = preload("res://PauseMenu/KnownClueEntry/KnownClueEntry.tscn")
const KnownClueEntry = preload("res://PauseMenu/KnownClueEntry/KnownClueEntry.gd")

var _option: int = 0

func get_pause_menu():
    return get_parent()

func get_room():
    return get_pause_menu().get_room()

func _update_option() -> void:
    # warning-ignore: integer_division
    $CurrentOption.position = $CluesList.position + Vector2(-16, KnownClueEntry.TOTAL_HEIGHT / 2)
    $CurrentOption.position.y += KnownClueEntry.TOTAL_HEIGHT * _option

func on_push() -> void:
    visible = true
    var ghost_database = get_room().get_ghost_database()
    var known_clues = ghost_database.get_known_clues()
    if len(known_clues) == 0:
        $NoCluesLabel.visible = true
        $CurrentOption.visible = false
    else:
        $NoCluesLabel.visible = false
        $CurrentOption.visible = true
        _option = 0
        _update_option()
        var y = 0
        for key in known_clues:
            var clue = ghost_database.get_clue_by_id(key)
            var info = ghost_database.get_info_by_id(key)
            var entry = KnownClueEntryScene.instance()
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
    var option_count = $CluesList.get_child_count()
    match input_type:
        "ui_down":
            if option_count > 0:
                _option += 1
                _option = (_option % option_count + option_count) % option_count
                _update_option()
        "ui_up":
            if option_count > 0:
                _option -= 1
                _option = (_option % option_count + option_count) % option_count
                _update_option()
        "ui_accept":
            if option_count > 0:
                var selected = $CluesList.get_child(_option)
                $GhostPanel.fill_in_data(selected.get_clue(), selected.get_info())
                get_pause_menu().push_control($GhostPanel)
        "ui_cancel":
            get_pause_menu().pop_control()
    return true # Modal
