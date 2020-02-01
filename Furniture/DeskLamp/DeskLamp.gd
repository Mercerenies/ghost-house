extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A lamp on a small end table." }
    ]

func set_direction(_a: int):
    pass

func lighting() -> Array:
    return [{
        "type": "circle",
        "position": position + Vector2(16, 16),
        "radius": 32,
        "color": Color(1, 1, 1, modulate.a)
    }]

func naturally_emits_light() -> bool:
    return true

func chance_of_turning_evil() -> float:
    return 0.10
func get_furniture_name():
    return "DeskLamp"
