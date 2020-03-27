extends Node2D

const FADE_OUT_SPEED = 1.0

var fading_out: bool = false
var velocity: Vector2

func _ready() -> void:
    velocity = Vector2(-16, 0).rotated(randf() * PI / 2 + PI / 4)

func _process(delta: float) -> void:
    position += velocity * delta

    if fading_out:
        modulate.a = Util.toward(modulate.a, delta * FADE_OUT_SPEED, 0)
        if modulate.a <= 0:
            queue_free()

func _on_FadeOutTimer_timeout():
    fading_out = true
