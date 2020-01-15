extends FurniturePlacement

const DiningTable = preload("DiningTable.tscn")

var _dims: Vector2

func _init(dims: Vector2):
    if dims.x < 2:
        dims.x = 2
    if dims.y < 2:
        dims.y = 2
    _dims = dims

func enumerate(room) -> Array:
    if not (room is GeneratorData.RoomData):
        return []
    var rect = Rect2(room.box.position * GeneratorData.TOTAL_CELL_SIZE, room.box.size * GeneratorData.TOTAL_CELL_SIZE)
    var arr = []
    for i in range(rect.size.x):
        for j in range(rect.size.y):
            arr.append({ "position": rect.position + Vector2(i, j) })
            arr.append({ "position": rect.position + Vector2(i, j) })
            arr.append({ "position": rect.position + Vector2(i, j) })
            arr.append({ "position": rect.position + Vector2(i, j) })
    return arr

func value_to_position(value) -> Rect2:
    return Rect2(value["position"], _dims)

func spawn_at(_room, value):
    var obj = DiningTable.instance()
    obj.set_dims(_dims)
    obj.position = value["position"] * 32
    return obj
