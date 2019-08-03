extends EdgeFurniturePlacement

const CabinetScene = preload("Cabinet.tscn")

func get_width() -> int:
    return 1

func spawn_at(position: Vector2, direction: int):
    var obj = CabinetScene.instance()
    obj.position = position * 32
    obj.set_direction(direction)
    return obj
