extends Node2D

func get_lighting():
    return get_node("../..")

func set_direction(a: int) -> void:
    $Flashlight.rotation = a * PI / 2.0
