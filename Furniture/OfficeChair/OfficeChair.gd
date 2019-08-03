extends Furniture

var interaction: Dictionary = {
        "start": [
             { "command": "say", "text": "An old office chair." }
        ]
    }

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

func on_interact() -> void:
    get_room().show_dialogue(interaction)
