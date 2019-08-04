extends EdgeFurniturePlacement

const FloorLampScene = preload("FloorLamp.tscn")

func get_width() -> int:
    return 1

func spawn_at(position: Vector2, direction: int):
    var obj = FloorLampScene.instance()
    obj.position = position * 32
    obj.set_direction(direction)
    return obj
