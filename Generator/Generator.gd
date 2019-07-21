extends Node
class_name Generator

class HallwayData:
    var id: int
    var data: Array
    func _init(id: int, data: Array):
        self.id = id
        self.data = data

const RoomScene = preload("res://Room/Room.tscn")
const PlayerScene = preload("res://Player/Player.tscn")

# _grid IDs
#   -2 - Empty (dead cell marker)
#   -1 - Empty
#   0 to 255 - Hallway identifier
#   256 to 2047 - Room identifier

var _data: Dictionary = {}
var _grid: Array = [] # Row major (y + x * h)
var _room: Room = null

func _init(room_data: Dictionary):
    _data = room_data

func _add_entity(pos: Vector2, entity: Object) -> void:
    _room.add_child(entity)
    entity.position = pos * 32
    _room.set_entity_cell(pos, entity)

func _produce_grid_array() -> void:
    _grid = []
    for i in range(_data['config']['width'] * _data['config']['height']):
        _grid.append(-1)

func _grid_get(pos: Vector2) -> int:
    var h = _data['config']['height']
    return _grid[pos.y + pos.x * h]

func _grid_set(pos: Vector2, value: int) -> void:
    var h = _data['config']['height']
    _grid[pos.y + pos.x * h] = value

func _random_dir() -> Vector2:
    match randi() % 4:
        0:
            return Vector2(1, 0)
        1:
            return Vector2(-1, 0)
        2:
            return Vector2(0, 1)
        3:
            return Vector2(0, -1)
    return Vector2(1, 0) # Idk

func _produce_hallway_attempt():
    var w = _data['config']['width']
    var h = _data['config']['height']
    var hall_length = Util.randi_range(4, min(w, h))
    var arr = []
    var startx = randi() % w
    var starty = randi() % h
    var x = startx
    var y = starty
    var dir = _random_dir()
    for _i in range(hall_length):
        if x < 2 or x >= w - 2 or y < 2 or y >= h - 2:
            return null # Out of bounds failure!
        arr.append(Vector2(x, y))
        if randf() < 0.10:
            dir = _random_dir()
        x += dir.x
        y += dir.y
    return arr

func _produce_hallway():
    for _attempt in range(20): # Try 20 times, then give up
        var hw = _produce_hallway_attempt()
        if hw != null:
            return hw
    return null

func _paint_hallway(hw: HallwayData) -> void:
    # TODO What about overlapping hallways?!
    for pos in hw.data:
        _grid_set(pos, hw.id)

func _merge_hallways(hws: Array) -> void:
    var cache = {}
    for hw in hws:
        for pos in hw.data:
            if cache.has(pos):
                # Merge: change every old_id into new_id
                var old_id = cache[pos].id
                var new_id = hw.id
                #print("Merging {} into {}".format([old_id, new_id], "{}"))
                for hwc in hws:
                    if hwc.id == old_id:
                        hwc.id = new_id
            else:
                cache[pos] = hw

func _produce_hallways(start_id: int = 0) -> void:
    var hws = []
    for i in range(start_id, start_id + 3):
        var hw = _produce_hallway()
        if hw != null:
            hws.append(HallwayData.new(i, hw))
    # It is always possible that the hallways generated overlapping one another. It's fine
    # if they did, but in that case we need to make sure the two overlapping hallways have
    # the same ID value. _merge_hallways ensures this by modifying the array.
    _merge_hallways(hws)
    for hw in hws:
        _paint_hallway(hw)

func _grid_to_room() -> void:
    var w = _data['config']['width']
    var h = _data['config']['height']
    var CELL_SIZE = 4
    for x in range(w):
        for y in range(h):
            var cell = _grid_get(Vector2(x, y))
            if cell >= 0:
                for i in range(CELL_SIZE):
                    for j in range(CELL_SIZE):
                        _room.set_tile_cell(Vector2(i + x * CELL_SIZE, j + y * CELL_SIZE), _room.Tile.DebugFloor)

func generate() -> Room:
    _room = RoomScene.instance()
    _produce_grid_array()
    _produce_hallways()
    _grid_to_room()
    print(_grid)
    #for i in range(_data['config']['width']):
    #    for j in range(_data['config']['height']):
    #        _room.set_tile_cell(Vector2(i, j), _room.Tile.DebugFloor)
    var player = PlayerScene.instance()
    _add_entity(Vector2(randi() % _data['config']['width'], randi() % _data['config']['height']), player)
    return _room
