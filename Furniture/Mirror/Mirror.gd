extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A mirror." }
    ]

func set_direction(a: int):
    # warning-ignore: integer_division
    $Sprite.frame = a / 2

func get_furniture_name():
    return "Mirror"
