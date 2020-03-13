extends Node2D

const FADE_OUT_SPEED = 1.0

var fading_out: bool = false
var velocity: Vector2

func _ready() -> void:
    velocity = Vector2(-1, 0).rotated(randf() * PI)

func _process(delta: float) -> void:
    position += velocity * delta

    if fading_out:
        modulate.a = Util.toward(modulate.a, delta * FADE_OUT_SPEED, 0)
        if modulate.a <= 0:
            queue_free()

# Requires an ItemInstance
func set_item(item) -> void:
    $Sprite.frame = item.get_icon_index()

func _on_FadeOutTimer_timeout():
    fading_out = true
