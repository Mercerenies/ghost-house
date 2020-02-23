extends Node2D

const RadialLight = preload("res://Lighting/RadialLight.tscn")

export(float, 0, 128, 1) var radius: float = 16.0
var _lighting = null

func _on_RadialLightSpawner_tree_entered():
    _lighting = RadialLight.instance()
    _lighting.radius = radius
    _lighting.position = position
    get_parent().get_room().get_lighting().add_light(_lighting)

func _on_RadialLightSpawner_tree_exiting():
    if _lighting != null and _lighting.is_inside_tree():
        _lighting.queue_free()
        _lighting = null

func get_light():
    return _lighting