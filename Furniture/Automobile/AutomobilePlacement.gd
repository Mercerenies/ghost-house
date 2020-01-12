extends FurniturePlacement

const AutomobileScene = preload("Automobile.tscn")

const WALL_SIZE = GeneratorData.WALL_SIZE

func enumerate(room) -> Array:
    if not (room is GeneratorData.RoomData):
        return []
    var rect = Rect2(room.box.position * GeneratorData.TOTAL_CELL_SIZE, room.box.size * GeneratorData.TOTAL_CELL_SIZE)
    var arr = []
    for i in range(rect.position.x + 1 + WALL_SIZE, rect.end.x - 2 - WALL_SIZE):
        for j in range(rect.position.y + 1 + WALL_SIZE, rect.end.y - 2 - WALL_SIZE):
            arr.append({ "position": Vector2(i, j) })
    return arr

func value_to_position(value) -> Rect2:
    return Rect2(value["position"], Vector2(2, 2))

func spawn_at(_room, value):
    var obj = AutomobileScene.instance()
    obj.position = value["position"] * 32
    obj.set_direction(randi() % 4)
    return obj
