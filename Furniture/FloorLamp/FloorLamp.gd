extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A floor lamp." }
    ]

func set_direction(a: int):
    pass

func lighting() -> Array:
    return [{
        "type": "circle",
        "position": position + Vector2(16, 16),
        "radius": 32,
        "color": Color(1, 1, 1, modulate.a)
    }]

func chance_of_turning_evil() -> float:
    return 0.10
