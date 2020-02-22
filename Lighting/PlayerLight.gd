extends Node2D

func get_lighting():
    return get_node("../..")

func _process(_delta: float) -> void:
    position = get_lighting().find_player().position