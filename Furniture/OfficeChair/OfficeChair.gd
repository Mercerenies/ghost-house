extends Furniture

func _ready() -> void:
    interaction = {
        "idle": [
             { "command": "say", "text": "An old office chair." }
        ]
    }

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

