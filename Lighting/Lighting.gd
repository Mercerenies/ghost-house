extends Node2D

const Player = preload("res://Player/Player.gd")
const Desaturate = preload("Desaturate.tres")

func _ready():
    var player = find_player()
    var sprite = Sprite.new()
    sprite.texture = $Viewport.get_texture()
    sprite.z_index = 1
    sprite.material = Desaturate
    sprite.position = Vector2(16, 16)
    player.add_child(sprite)

func get_room():
    return get_parent()

func add_light(light: Node2D) -> void:
    $Viewport.add_child(light)

func find_player():
    var marked = get_room().get_marked_entities()
    if Mark.PLAYER in marked:
        return marked[Mark.PLAYER]
    for ent in get_room().get_entities():
        if ent is Player:
            return ent
    return null

func _process(_delta: float) -> void:
    #var player = find_player()
    #if player != null:
    #    position = player.position
    update()
