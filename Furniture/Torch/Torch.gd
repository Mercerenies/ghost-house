extends Furniture

func _ready() -> void:
    unposition_self()

func set_direction(a: int):
    $Sprite.frame = a % 4

func lighting() -> Array:
    var pos = position + Vector2(16, 16) + Vector2(-12, 0).rotated($Sprite.frame * PI / 2.0)
    if $Sprite.frame == 1:
        pos += Vector2(0, -8)
    return [{
        "type": "circle",
        "position": pos,
        "radius": 24,
        "color": Color(1, 1, 1, 1)
    }]

func naturally_emits_light() -> bool:
    return true

func chance_of_turning_evil() -> float:
    return 0.0
func get_furniture_name():
    return "Torch"
