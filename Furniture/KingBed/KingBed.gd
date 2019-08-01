extends Furniture

var interaction: Dictionary = {
        "start": [
             { "command": "say", "text": "A luxurious king-sized bed." }
        ]
    }

func _ready():
    pass

func set_direction(a: int):
    $Sprite.frame = a

func on_interact() -> void:
    get_room().show_dialogue(interaction)
