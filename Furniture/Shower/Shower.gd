extends Furniture

var interaction: Dictionary = {
        "start": [
             { "command": "say", "text": "An old shower." }
        ]
    }

func _ready():
    set_dims(Vector2(2, 1))

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4
    set_dims(Vector2(2, 1) if a % 2 == 1 else Vector2(1, 2))

func on_interact() -> void:
    get_room().show_dialogue(interaction)
