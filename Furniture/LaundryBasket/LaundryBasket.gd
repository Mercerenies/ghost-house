extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A basket for laundry." }
    ]
    $Sprite.frame = randi() % 2

func set_direction(a: int):
    pass

func get_furniture_name():
    return "LaundryBasket"
