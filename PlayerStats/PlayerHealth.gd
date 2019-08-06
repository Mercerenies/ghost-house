tool
extends Node2D

export var max_health: int = 5
export var health: int = 5

const _image: Texture = preload("res://PlayerStats/Heart.png")

func _ready():
    pass

func _draw() -> void:
    var off = Rect2(0, 0, 32, 32)
    var on = Rect2(32, 0, 32, 32)
    for i in range(max_health):
        var pos = position + Vector2(i * 32, 0)
        draw_texture_rect_region(_image, Rect2(pos, Vector2(32, 32)), off if i >= health else on)

func set_health(a: int) -> void:
    health = int(clamp(a, 0, max_health))
    update()

func get_health() -> int:
    return health
