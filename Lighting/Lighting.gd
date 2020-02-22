extends Node2D

const Player = preload("res://Player/Player.gd")
const Desaturate = preload("Desaturate.tres")

func _ready():
    pass

func get_room():
    return get_parent()

func get_darkbox():
    return $Viewport/DarkBox

func find_player():
    for ent in get_room().get_entities():
        if ent is Player:
            return ent
    return null

func _process(_delta: float) -> void:
    #var player = find_player()
    #if player != null:
    #    position = player.position
    update()
