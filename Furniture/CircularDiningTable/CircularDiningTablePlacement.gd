extends FurniturePlacement

const CircularDiningTable = preload("CircularDiningTable.tscn")

func enumerate(room) -> Array:
    if not (room is GeneratorData.RoomData):
        return []
    var rect = Rect2(room.box.position * GeneratorData.TOTAL_CELL_SIZE, room.box.size * GeneratorData.TOTAL_CELL_SIZE)
    var arr = []
    for i in range(rect.size.x):
        for j in range(rect.size.y):
            arr.append({ "position": rect.position + Vector2(i, j) })
    return arr

func value_to_position(value) -> Rect2:
    return Rect2(value["position"], Vector2(2, 2))

func spawn_at(_room, value):
    var obj = CircularDiningTable.instance()
    obj.position = value["position"] * 32
    return obj
