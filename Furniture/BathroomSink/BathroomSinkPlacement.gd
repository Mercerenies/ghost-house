extends FurniturePlacement

const BathroomSinkScene = preload("BathroomSink.tscn")

func enumerate(room) -> Array:
    if not (room is GeneratorData.RoomData):
        return []
    var rect = Rect2(room.box.position * GeneratorData.TOTAL_CELL_SIZE, room.box.size * GeneratorData.TOTAL_CELL_SIZE)
    var arr = []
    for i in range(rect.size.x - 2):
        # Top edge
        arr.append({ "position": rect.position + Vector2(i + 1, 1), "direction": 1 })
        # Bottom edge
        arr.append({ "position": rect.end + Vector2(- i - 2, -2), "direction": 3 })
    for i in range(rect.size.y - 2):
        # Left edge
        arr.append({ "position": rect.position + Vector2(1, i + 1), "direction": 0 })
        # Right edge
        arr.append({ "position": rect.end + Vector2(-2, - i - 2), "direction": 2 })
    return arr

func value_to_position(value) -> Rect2:
    return Rect2(value["position"], Vector2(1, 2) if value["direction"] % 2 == 0 else Vector2(2, 1))

func spawn_at(_room, value):
    var obj = BathroomSinkScene.instance()
    obj.position = value["position"] * 32
    obj.set_direction(value["direction"])
    return [obj]
