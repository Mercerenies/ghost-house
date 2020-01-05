extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "Everything but the kitchen sink... oh wait, there it is." }
    ]
    set_dims(Vector2(2, 1))

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4
    set_dims(Vector2(2, 1) if a % 2 == 1 else Vector2(1, 2))

func get_furniture_name():
    return "KitchenSink"
