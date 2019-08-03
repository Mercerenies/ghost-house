extends Furniture

var interaction: Dictionary = {
        "start": [
             { "command": "say", "text": "A laundry machine. It doesn't appear to be in use right now." }
        ]
    }

func _ready():
    pass

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

func on_interact() -> void:
    get_room().show_dialogue(interaction)
