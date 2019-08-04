extends Furniture

var interaction: Dictionary = {
        "start": [
             { "command": "say", "text": "A mirror." }
        ]
    }

func set_direction(a: int):
    $Sprite.frame = floor(a / 2)

func on_interact() -> void:
    get_room().show_dialogue(interaction)
