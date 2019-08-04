extends Node2D

func _ready():
    pass

func get_lighting():
    return get_parent().get_parent()

func get_room():
    return get_lighting().get_room()

func find_player():
    return get_lighting().find_player()
