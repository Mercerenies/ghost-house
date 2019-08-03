extends Furniture

var interaction: Dictionary = {
        "start": [
             { "command": "say", "text": "A toilet. It seems to be in working order." }
        ]
    }

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

func on_interact() -> void:
    get_room().show_dialogue(interaction)
