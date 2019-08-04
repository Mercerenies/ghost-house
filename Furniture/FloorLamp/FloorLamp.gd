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
