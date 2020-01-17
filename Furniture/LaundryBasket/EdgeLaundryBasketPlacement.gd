extends EdgeFurniturePlacement

const LaundryBasketScene = preload("LaundryBasket.tscn")

func get_width() -> int:
    return 1

func spawn_at(position: Vector2, direction: int):
    var obj = LaundryBasketScene.instance()
    obj.position = position * 32
    obj.set_direction(direction)
    return obj
