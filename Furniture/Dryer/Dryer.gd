extends Furniture

func _ready() -> void:
    interaction = {
        "idle": [
             { "command": "say", "text": "A dryer. It doesn't appear to be in use right now." }
        ]
    }

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

