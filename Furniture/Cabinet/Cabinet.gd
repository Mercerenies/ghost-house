extends Furniture

func _ready() -> void:
    interaction = {
        "idle": [
             { "command": "say", "text": "A large cabinet above a set of drawers." }
        ]
    }

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

