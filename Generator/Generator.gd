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
#   -3 - OOB
#   -2 - Empty (dead cell marker)
#   -1 - Empty
#   0 to 255 - Hallway identifier
#   256 to 2047 - Room identifier

const ID_OOB = -3
const ID_DEAD = -2
const ID_EMPTY = -1
const ID_HALLS = 0
const ID_ROOMS = 256

var _data: Dictionary = {}
var _grid: Array = [] # Row major (y + x * h)
var _room: Room = null

const CELL_SIZE = 4
const WALL_SIZE = 1
const TOTAL_CELL_SIZE = CELL_SIZE + WALL_SIZE * 2

func _init(room_data: Dictionary):
    _data = room_data

func _add_entity(pos: Vector2, entity: Object) -> void:
    _room.add_child(entity)
    entity.position = pos * 32
    _room.set_entity_cell(pos, entity)

func _produce_grid_array() -> void:
    _grid = []
    for i in range(_data['config']['width'] * _data['config']['height']):
        _grid.append(ID_EMPTY)

func _grid_get(pos: Vector2) -> int:
    var h = _data['config']['height']
    if pos.y + pos.x * h < 0 or pos.y + pos.x * h >= len(_grid):
        return ID_OOB
    return _grid[pos.y + pos.x * h]

func _grid_set(pos: Vector2, value: int) -> void:
    var h = _data['config']['height']
    _grid[pos.y + pos.x * h] = value

func _can_draw_hypothetical_box(box: Rect2, hypo_box: Rect2) -> bool:
    if box.intersects(hypo_box):
        return false
    for i in range(box.size.x):
        for j in range(box.size.y):
            var pos = _grid_get(Vector2(box.position.x + i, box.position.y + j))
            if pos == ID_OOB or pos >= ID_HALLS:
                return false
    return true

func _can_draw_box(box: Rect2) -> bool:
    return _can_draw_hypothetical_box(box, Rect2(Vector2(), Vector2()))

func _is_cell_hypothetically_dead(pos: Vector2, new_box: Rect2) -> bool:
    if _can_draw_hypothetical_box(Rect2(pos, Vector2(2, 2)), new_box):
        return false
    if _can_draw_hypothetical_box(Rect2(pos + Vector2(-1, 0), Vector2(2, 2)), new_box):
        return false
    if _can_draw_hypothetical_box(Rect2(pos + Vector2(0, -1), Vector2(2, 2)), new_box):
        return false
    if _can_draw_hypothetical_box(Rect2(pos + Vector2(-1, -1), Vector2(2, 2)), new_box):
        return false
    return true

func _is_cell_dead(pos: Vector2) -> bool:
    return _is_cell_hypothetically_dead(pos, Rect2(Vector2(), Vector2()))

func _mark_dead_cells() -> void:
    var w = _data['config']['width']
    var h = _data['config']['height']
    for i in range(w):
        for j in range(h):
            if _grid_get(Vector2(i, j)) == ID_EMPTY and _is_cell_dead(Vector2(i, j)):
                _grid_set(Vector2(i, j), ID_DEAD)

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

func _produce_hallways(start_id: int = ID_HALLS) -> void:
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

func _draw_base_room(pos: Vector2) -> void:
    var xpos = pos.x * TOTAL_CELL_SIZE + WALL_SIZE
    var ypos = pos.y * TOTAL_CELL_SIZE + WALL_SIZE
    var cell = _grid_get(pos)
    if cell >= 0:
        # Draw the contents of the room
        for i in range(CELL_SIZE):
            for j in range(CELL_SIZE):
                _room.set_tile_cell(Vector2(xpos + i, ypos + j), _room.Tile.DebugFloor)
        # Now draw the walls
        # Top Wall
        for i in range(CELL_SIZE):
            if _grid_get(pos + Vector2(0, -1)) == cell:
                _room.set_tile_cell(Vector2(xpos + i, ypos - 1), _room.Tile.DebugFloor)
            else:
                _room.set_tile_cell(Vector2(xpos + i, ypos - 1), _room.Tile.DebugWall)
        # Bottom Wall
        for i in range(CELL_SIZE):
            if _grid_get(pos + Vector2(0, 1)) == cell:
                _room.set_tile_cell(Vector2(xpos + i, ypos + CELL_SIZE), _room.Tile.DebugFloor)
            else:
                _room.set_tile_cell(Vector2(xpos + i, ypos + CELL_SIZE), _room.Tile.DebugWall)
        # Left Wall
        for i in range(CELL_SIZE):
            if _grid_get(pos + Vector2(-1, 0)) == cell:
                _room.set_tile_cell(Vector2(xpos - 1, ypos + i), _room.Tile.DebugFloor)
            else:
                _room.set_tile_cell(Vector2(xpos - 1, ypos + i), _room.Tile.DebugWall)
        # Right Wall
        for i in range(CELL_SIZE):
            if _grid_get(pos + Vector2(1, 0)) == cell:
                _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos + i), _room.Tile.DebugFloor)
            else:
                _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos + i), _room.Tile.DebugWall)
        # Upper Left Wall
        if _grid_get(pos + Vector2(-1, 0)) == cell and _grid_get(pos + Vector2(0, -1)) == cell and _grid_get(pos + Vector2(-1, -1)) == cell:
            _room.set_tile_cell(Vector2(xpos - 1, ypos - 1), _room.Tile.DebugFloor)
        else:
            _room.set_tile_cell(Vector2(xpos - 1, ypos - 1), _room.Tile.DebugWall)
        # Upper Right Wall
        if _grid_get(pos + Vector2(1, 0)) == cell and _grid_get(pos + Vector2(0, -1)) == cell and _grid_get(pos + Vector2(1, -1)) == cell:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos - 1), _room.Tile.DebugFloor)
        else:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos - 1), _room.Tile.DebugWall)
        # Lower Left Wall
        if _grid_get(pos + Vector2(-1, 0)) == cell and _grid_get(pos + Vector2(0, 1)) == cell and _grid_get(pos + Vector2(-1, 1)) == cell:
            _room.set_tile_cell(Vector2(xpos - 1, ypos + CELL_SIZE), _room.Tile.DebugFloor)
        else:
            _room.set_tile_cell(Vector2(xpos - 1, ypos + CELL_SIZE), _room.Tile.DebugWall)
        # Lower Right Wall
        if _grid_get(pos + Vector2(1, 0)) == cell and _grid_get(pos + Vector2(0, 1)) == cell and _grid_get(pos + Vector2(1, 1)) == cell:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos + CELL_SIZE), _room.Tile.DebugFloor)
        else:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos + CELL_SIZE), _room.Tile.DebugWall)

func _open_all_doorways() -> void:
    # This code literally only exists for debugging purposes.
    var w = _data['config']['width']
    var h = _data['config']['height']
    for x in range(w):
        for y in range(h):
            var xpos = x * TOTAL_CELL_SIZE + WALL_SIZE
            var ypos = y * TOTAL_CELL_SIZE + WALL_SIZE
            _room.set_tile_cell(Vector2(xpos - 1, ypos + 1), _room.Tile.DebugFloor)
            _room.set_tile_cell(Vector2(xpos - 1, ypos + 2), _room.Tile.DebugFloor)
            _room.set_tile_cell(Vector2(xpos + 1, ypos - 1), _room.Tile.DebugFloor)
            _room.set_tile_cell(Vector2(xpos + 2, ypos - 1), _room.Tile.DebugFloor)
            _room.set_tile_cell(Vector2(xpos + 4, ypos + 1), _room.Tile.DebugFloor)
            _room.set_tile_cell(Vector2(xpos + 4, ypos + 2), _room.Tile.DebugFloor)
            _room.set_tile_cell(Vector2(xpos + 1, ypos + 4), _room.Tile.DebugFloor)
            _room.set_tile_cell(Vector2(xpos + 2, ypos + 4), _room.Tile.DebugFloor)

func _grid_to_room() -> void:
    var w = _data['config']['width']
    var h = _data['config']['height']
    for x in range(w):
        for y in range(h):
            _draw_base_room(Vector2(x, y))
    # DEBUG CODE
    _open_all_doorways()

func generate() -> Room:
    _room = RoomScene.instance()
    _produce_grid_array()
    _produce_hallways()
    _mark_dead_cells()
    _grid_to_room()
    print(_grid)
    #for i in range(_data['config']['width']):
    #    for j in range(_data['config']['height']):
    #        _room.set_tile_cell(Vector2(i, j), _room.Tile.DebugFloor)
    var player = PlayerScene.instance()
    _add_entity(Vector2(1, 1), player)
    return _room
