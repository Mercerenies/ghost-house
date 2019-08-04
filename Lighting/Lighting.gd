extends Node2D

const Player = preload("res://Player/Player.gd")

func _ready():
    pass

func get_room():
    return get_parent()

func find_player():
    for ent in get_room().get_entities():
        if ent is Player:
            return ent
    return null

func _process(_delta: float) -> void:
    position = find_player().position
    update()

func _draw() -> void:
    draw_texture_rect($Viewport.get_texture(), Rect2(- $Viewport.size / 2.0, Vector2($Viewport.size.x, - $Viewport.size.y)), false)