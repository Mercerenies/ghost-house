extends Node2D

# This whole scene is obsolete. It's been replaced by GhostVisibilityParticleSystem.

var vel: Vector2
var lifetime: float

func _ready() -> void:
    var speed = 2 * randf() + 10
    vel = Vector2(speed, 0).rotated(randf() * 2 * PI)
    lifetime = randf() * 2 + 1
    var scale_factor = randf() * 0.75 + 0.5
    scale = Vector2(scale_factor, scale_factor)

func _process(delta: float) -> void:
    position += vel * delta
    lifetime -= delta
    if lifetime <= 0:
        queue_free()