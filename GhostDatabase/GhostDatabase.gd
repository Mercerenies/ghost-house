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
