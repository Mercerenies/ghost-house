extends Furniture

var interaction: Dictionary = {
        "start": [
             { "command": "say", "text": "A shelf full of old books." }
        ]
    }

func set_direction(a: int):
    $Sprite.frame = a % 2

func on_interact() -> void:
    get_room().show_dialogue(interaction)
