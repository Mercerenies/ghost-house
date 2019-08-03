extends Furniture

var interaction: Dictionary = {
        "start": [
             { "command": "say", "text": "A large cabinet above a set of drawers." }
        ]
    }

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

func on_interact() -> void:
    get_room().show_dialogue(interaction)
