extends Furniture

var interaction: Dictionary = {
        "start": [
             { "command": "say", "text": "A strange small green box. It does little of interest." }
        ]
    }

func on_interact() -> void:
    get_room().show_dialogue(interaction)
