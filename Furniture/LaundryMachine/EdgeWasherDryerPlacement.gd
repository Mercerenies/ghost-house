extends EdgeFurniturePlacement

const LaundryMachineScene = preload("LaundryMachine.tscn")
const DryerScene = preload("../Dryer/Dryer.tscn")

func get_width() -> int:
    return 2

func spawn_at(position: Vector2, direction: int):
    var obj1 = LaundryMachineScene.instance()
    var obj2 = DryerScene.instance()
    if randi() % 2 == 0:
        var tmp = obj1
        obj1 = obj2
        obj2 = tmp
    obj1.position = position * 32
    obj1.set_direction(direction)
    obj2.position = position * 32 + (Vector2(32, 0) if direction % 2 == 1 else Vector2(0, 32))
    obj2.set_direction(direction)
    return [obj1, obj2]
