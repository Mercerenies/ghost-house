extends Furniture

func _ready() -> void:
    unposition_self()

func set_direction(a: int):
    $Sprite.frame = a % 4

func on_interact() -> void:
    pass

func lighting() -> Array:
    var pos = position + Vector2(16, 16) + Vector2(-12, 0).rotated($Sprite.frame * PI / 2.0)
    if $Sprite.frame == 1:
        pos += Vector2(0, -8)
    return [{
        "type": "circle",
        "position": pos,
        "radius": 24
    }]

func unposition_self() -> void:
    get_room().set_entity_cell(cell, null)
