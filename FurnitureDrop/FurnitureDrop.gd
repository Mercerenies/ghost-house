extends Node2D

export var speed: float = 1000
export var angular_speed: float = 3 * PI

func assign_sprite(old_sprite: Sprite) -> void:
    var sprite = old_sprite.duplicate()
    sprite.scale *= 5
    sprite.position = Vector2()
    add_child(sprite)

func _ready():
    position = Vector2(get_viewport_rect().size.x / 2, - 64)
    rotation = 0
    if randf() < 0.5:
        angular_speed *= -1

func _process(delta: float) -> void:
    position.y += speed * delta
    rotation += angular_speed * delta
    if position.y > get_viewport_rect().size.y + 64:
        queue_free()
