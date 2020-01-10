extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A large wardrobe, almost big enough to walk into." }
    ]

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

func get_furniture_name():
    return "Wardrobe"
