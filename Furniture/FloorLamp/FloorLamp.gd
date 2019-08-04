extends Furniture

var interaction: Dictionary = {
        "start": [
             { "command": "say", "text": "A floor lamp." }
        ]
    }

func set_direction(a: int):
    pass

func on_interact() -> void:
    get_room().show_dialogue(interaction)

func lighting() -> Array:
    return [{"position": position + Vector2(16, 16), "radius": 32}]
