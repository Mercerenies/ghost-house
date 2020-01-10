extends FurniturePlacement

const MirrorScene = preload("Mirror.tscn")

func enumerate(room) -> Array:
    if not (room is GeneratorData.RoomData):
        return []
    var rect = Rect2(room.box.position * GeneratorData.TOTAL_CELL_SIZE, room.box.size * GeneratorData.TOTAL_CELL_SIZE)
    var arr = []
    for i in range(rect.size.x - 2):
        # Top edge
        arr.append({ "position": rect.position + Vector2(i + 1, 1), "direction": 1 })
        # Bottom edge
        arr.append({ "position": rect.end + Vector2(- i - 2, -3), "direction": 3 })
    return arr

func value_to_position(value) -> Rect2:
    return Rect2(value["position"], Vector2(1, 2))

func spawn_at(_room, value):
    var obj = MirrorScene.instance()
    obj.position = value["position"] * 32
    obj.set_direction(value["direction"])
    return obj
