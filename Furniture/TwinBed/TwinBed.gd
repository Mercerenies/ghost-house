extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A nice, cozy twin bed." }
    ]

func set_direction(a: int):
    $Sprite.frame = a
    set_dims(Vector2(2, 1) if a % 2 == 0 else Vector2(1, 2))

func get_furniture_name() -> String:
    return "TwinBed"
