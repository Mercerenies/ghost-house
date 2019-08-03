extends EdgeFurniturePlacement

const KitchenSinkScene = preload("KitchenSink.tscn")

func get_width() -> int:
    return 2

func spawn_at(position: Vector2, direction: int):
    var obj = KitchenSinkScene.instance()
    obj.position = position * 32
    obj.set_direction(direction)
    return obj
