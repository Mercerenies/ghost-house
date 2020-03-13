extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A convenient bench for putting your shoes on." }
    ]

func set_direction(a: int):
    $Sprite.frame = (a + 1) % 2
    set_dims(Vector2(2, 1) if a % 2 == 1 else Vector2(1, 2))

func get_furniture_name():
    return "Bench"
