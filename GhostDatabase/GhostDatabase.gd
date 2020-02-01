extends Node

# _ghost_data comes straight from the JSON file. _ghost_info
# is the added details provided by GhostGenerator.
var _ghost_data: Dictionary = {}
var _ghost_info: Dictionary = {}
var _known_clues: Array = []

func set_ghost_data(ghost_data: Dictionary) -> void:
    _ghost_data = ghost_data

func set_ghost_info(ghost_info: Dictionary) -> void:
    _ghost_info = ghost_info
    # DEBUG CODE
    for key in _ghost_info:
        meet_ghost(key)

func meet_ghost(ghost_key: String) -> void:
    if not (ghost_key in _known_clues):
        _known_clues.push_back(ghost_key)

func get_known_clues() -> Array:
    return _known_clues

func get_clue_by_id(key: String) -> Dictionary:
    assert(key in _ghost_data)
    return _ghost_data[key]["statement"]

func get_info_by_id(key: String) -> GhostInfo:
    assert(key in _ghost_info)
    return _ghost_info[key]

