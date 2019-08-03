extends EdgeFurniturePlacement

const DresserScene = preload("Dresser.tscn")

func get_width() -> int:
    return 2

func spawn_at(position: Vector2, direction: int):
    var obj = DresserScene.instance()
    obj.position = position * 32
    obj.set_direction(direction)
    return obj
