extends Node2D

const Player = preload("res://Player/Player.gd")
const Desaturate = preload("Desaturate.tres")

# Okay, so the way the new lighting system works is this. If your node
# wants to produce light, it needs to create a child node of
# $Viewport. That child should draw the light in (possible
# transparent) white using the subtractive blend mode (this can be
# done via the LightingMaterial.tres material). The relevant lighting
# node should be added to the tree in reaction to the tree_entered
# signal and removed in tree_exiting. RadialLight (and its
# corresponding helper RadialLightSpawner) is a useful example of
# this, which handles simple circular lighting. Remember that the node
# in question is responsible for updating its light's position, as the
# light is a child of a viewport and thus is not in relative position
# to the owner node.

func _ready():
    var player = find_player()
    var sprite = Sprite.new()
    sprite.texture = $Viewport.get_texture()
    sprite.z_index = 1
    sprite.material = Desaturate
    sprite.position = Vector2(16, 16)
    player.add_child(sprite)
    if !visible:
        sprite.visible = false

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
