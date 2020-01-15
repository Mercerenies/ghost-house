extends FurniturePlacement

const BathtubScene = preload("Bathtub.tscn")

func enumerate(room) -> Array:
    if not (room is GeneratorData.RoomData):
        return []
    var rect = Rect2(room.box.position * GeneratorData.TOTAL_CELL_SIZE, room.box.size * GeneratorData.TOTAL_CELL_SIZE)
    var arr = []
    for i in range(rect.size.x):
        for j in range(rect.size.y):
            arr.append({ "position": rect.position + Vector2(i, j), "direction": 0 })
            arr.append({ "position": rect.position + Vector2(i, j), "direction": 1 })
            arr.append({ "position": rect.position + Vector2(i, j), "direction": 2 })
            arr.append({ "position": rect.position + Vector2(i, j), "direction": 3 })
    return arr

func value_to_position(value) -> Rect2:
    return Rect2(value["position"], Vector2(2, 1) if value["direction"] % 2 == 1 else Vector2(1, 2))

func spawn_at(_room, value, cb):
    var obj = BathtubScene.instance()
    obj.position = value["position"] * 32
    obj.set_direction(value["direction"])
    cb.call(obj)
