extends Furniture

func _ready() -> void:
    interaction = {
        "idle": [
             { "command": "say", "text": "A toilet. It seems to be in working order." }
        ]
    }

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

