extends Furniture

func _ready() -> void:
    interaction = {
        "idle": [
             { "command": "say", "text": "A shelf full of old books." }
        ]
    }
    set_dims(Vector2(2, 1))

func set_direction(a: int):
    $Sprite.frame = (a + 1) % 2
    set_dims(Vector2(2, 1) if a % 2 == 1 else Vector2(1, 2))

