extends Furniture

func _ready() -> void:
    interaction = {
        "idle": [
             { "command": "say", "text": "A shelf full of old books." }
        ]
    }

func set_direction(a: int):
    $Sprite.frame = (a + 1) % 2

