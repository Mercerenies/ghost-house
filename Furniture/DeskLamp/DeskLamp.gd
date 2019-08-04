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
