extends EdgeFurniturePlacement

const LongCabinetScene = preload("LongCabinet.tscn")

func get_width() -> int:
    return 2

func spawn_at(position: Vector2, direction: int):
    var obj = LongCabinetScene.instance()
    obj.position = position * 32
    obj.set_direction(direction)
    return obj
