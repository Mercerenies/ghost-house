extends Furniture

var interaction: Dictionary = {
        "start": [
             { "command": "say", "text": "A lamp on a small end table." }
        ]
    }

func set_direction(a: int):
    pass

func on_interact() -> void:
    get_room().show_dialogue(interaction)

func lighting() -> Array:
    return [{"type": "circle", "position": position + Vector2(16, 16), "radius": 32}]
