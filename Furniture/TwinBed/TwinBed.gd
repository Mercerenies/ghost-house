extends Furniture

var interaction: Dictionary = {
        "start": [
             { "command": "say", "text": "A nice, cozy twin bed." }
        ]
    }

func _ready():
    set_dims(Vector2(2, 1))

func set_direction(a: int):
    $Sprite.frame = a
    set_dims(Vector2(2, 1) if a % 2 == 0 else Vector2(1, 2))

func on_interact() -> void:
    get_room().show_dialogue(interaction)
