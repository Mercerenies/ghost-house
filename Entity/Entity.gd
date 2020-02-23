extends Node2D
class_name Entity

func get_room():
    return get_parent().get_parent()

func _ready():
    position_self()

func position_self() -> void:
    pass

func on_interact() -> void:
    pass

func on_debug_tap() -> void:
    pass

func naturally_emits_light() -> bool:
    return false
