extends Node2D

# A helper for RadialLight. Simply make this a direct child of an
# entity and set its radius to make the entity in question produce
# radial light. Don't forget to update the radial light's position
# whenever the entity moves.

const RadialLight = preload("res://Lighting/RadialLight.tscn")

export(float, 0, 128, 1) var radius: float = 16.0
var _lighting = null

func _on_RadialLightSpawner_tree_entered():
    _lighting = RadialLight.instance()
    _lighting.radius = radius
    _lighting.position = global_position
    get_parent().get_room().get_lighting().add_light(_lighting)

func _on_RadialLightSpawner_tree_exiting():
    if _lighting != null and _lighting.is_inside_tree():
        _lighting.queue_free()
        _lighting = null

func get_light():
    return _lighting
