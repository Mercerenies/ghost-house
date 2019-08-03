extends EdgeFurniturePlacement

const OfficeChairScene = preload("OfficeChair.tscn")

func get_width() -> int:
    return 1

func spawn_at(position: Vector2, direction: int):
    var obj = OfficeChairScene.instance()
    obj.position = position * 32
    obj.set_direction(direction)
    return obj
