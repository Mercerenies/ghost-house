extends Furniture

func _ready() -> void:
    interaction = {
        "idle": [
             { "command": "say", "text": "A lamp on a small end table." }
        ]
    }

func set_direction(a: int):
    pass


func lighting() -> Array:
    return [{"type": "circle", "position": position + Vector2(16, 16), "radius": 32}]
