extends Node
class_name Generator

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData
const Graph = GeneratorData.Graph

const RoomScene = preload("res://Room/Room.tscn")
const PlayerScene = preload("res://Player/Player.tscn")

# _grid IDs
#   -3 - OOB
#   -2 - Empty (dead cell marker)
#   -1 - Empty
#   0 to 255 - Hallway identifier
#   256 to 2047 - Room identifier

const ID_OOB = GeneratorData.ID_OOB
const ID_DEAD = GeneratorData.ID_DEAD
const ID_EMPTY = GeneratorData.ID_EMPTY
const ID_HALLS = GeneratorData.ID_HALLS
const ID_ROOMS = GeneratorData.ID_ROOMS

var _data: Dictionary = {}
var _grid: Array = [] # Row major (y + x * h)
var _room: Room = null
var _boxes: Dictionary = {}
var _connections: Array = []

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
    var w = _data['config']['width']
    var h = _data['config']['height']
    if pos.x < 0 or pos.y < 0 or pos.x >= w or pos.y >= h:
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

func _creates_dead_cells(box: Rect2) -> bool:
    var pos
    # Top and bottom edges
    for i in range(-1, box.size.x + 1):
        pos = box.position + Vector2(i, -1)
        if _grid_get(pos) == ID_EMPTY and _is_cell_hypothetically_dead(pos, box):
            return true
        pos = box.end - Vector2(i + 1, 0)
        if _grid_get(pos) == ID_EMPTY and _is_cell_hypothetically_dead(pos, box):
            return true
    # Left and right edges
    for i in range(-1, box.size.y + 1):
        pos = box.position + Vector2(-1, i)
        if _grid_get(pos) == ID_EMPTY and _is_cell_hypothetically_dead(pos, box):
            return true
        pos = box.end - Vector2(0, i + 1)
        if _grid_get(pos) == ID_EMPTY and _is_cell_hypothetically_dead(pos, box):
            return true
    return false

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
    _boxes[hw.id] = hw

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

func _enumerate_rectangles(pos: Vector2) -> Dictionary:
    # This is an absolute BS O(n^4) (at least in principle) algorithm right now.
    # Please please please for the love of all that is good, make this more efficient.
    var dead = []
    var alive = []
    for width in [2, 3, 4]:
        for height in [2, 3, 4]:
            for left_offset in range(1 - width, 1):
                for top_offset in range(1 - height, 1):
                    var rect = Rect2(pos + Vector2(left_offset, top_offset), Vector2(width, height))
                    if _can_draw_box(rect):
                        if _creates_dead_cells(rect):
                            dead.append(rect)
                        else:
                            alive.append(rect)
    return {
        'dead': dead,
        'alive': alive
    }

func _paint_room(id: int, rect: Rect2) -> void:
    for x in range(rect.position.x, rect.end.x):
        for y in range(rect.position.y, rect.end.y):
            _grid_set(Vector2(x, y), id)
    _boxes[id] = RoomData.new(id, rect)

func _produce_live_rooms(start_id: int = ID_ROOMS) -> int:
    _mark_dead_cells()

    var current_id = start_id
    var w = _data['config']['width']
    var h = _data['config']['height']
    var cells = []
    for i in range(w):
        for j in range(h):
            if _grid_get(Vector2(i, j)) == ID_EMPTY:
                cells.append(Vector2(i, j))
    cells.shuffle()

    for pos in cells:
        if _grid_get(pos) != ID_EMPTY:
            continue
        var rects = _enumerate_rectangles(pos)
        var dead = rects['dead']
        var alive = rects['alive']
        var rect
        #print("Cell: {0}\nDead: {1}\nAlive: {2}".format([pos, str(dead), str(alive)]))
        if not alive.empty():
            rect = alive[randi() % len(alive)]
        else:
            #print("DEAD")
            rect = dead[randi() % len(dead)]
        _paint_room(current_id, rect)
        current_id += 1
        _mark_dead_cells()

    return current_id

func _produce_dead_rooms(start_id: int) -> int:
    var current_id = start_id
    var w = _data['config']['width']
    var h = _data['config']['height']

    for x in range(w):
        for y in range(h):
            if _grid_get(Vector2(x, y)) < ID_HALLS and not _grid_get(Vector2(x, y)) == ID_OOB:
                if randf() < 0.5:
                    # Expand to the right
                    var ww = 1
                    while ww < 4 and _grid_get(Vector2(x + ww, y)) < ID_HALLS and not _grid_get(Vector2(x + ww, y)) == ID_OOB:
                        ww += 1
                    _paint_room(current_id, Rect2(x, y, ww, 1))
                else:
                    # Expand to the bottom
                    var hh = 1
                    while hh < 4 and _grid_get(Vector2(x, y + hh)) < ID_HALLS and not _grid_get(Vector2(x, y + hh)) == ID_OOB:
                        hh += 1
                    _paint_room(current_id, Rect2(x, y, 1, hh))
                current_id += 1

    return current_id

func _produce_adjacency_graph() -> Graph:
    var w = _data['config']['width']
    var h = _data['config']['height']
    var graph = Graph.new()
    var adja = graph.adja
    for x in range(w):
        for y in range(h):
            var a = _grid_get(Vector2(x, y))
            var b = _grid_get(Vector2(x + 1, y))
            var c = _grid_get(Vector2(x, y + 1))
            if a >= ID_HALLS and not adja.has(a):
                adja[a] = []
            if b >= ID_HALLS and not adja.has(b):
                adja[b] = []
            if c >= ID_HALLS and not adja.has(c):
                adja[c] = []
            if a >= ID_HALLS and b >= ID_HALLS and a != b:
                var link = [Vector2(x, y), Vector2(x + 1, y)]
                adja[a].append({ "pos": link, "value": b })
                adja[b].append({ "pos": link, "value": a })
            if a >= ID_HALLS and c >= ID_HALLS and a != c:
                var link = [Vector2(x, y), Vector2(x, y + 1)]
                adja[a].append({ "pos": link, "value": c })
                adja[c].append({ "pos": link, "value": a })
    return graph

func _draw_base_room(pos: Vector2) -> void:
    var xpos = pos.x * TOTAL_CELL_SIZE + WALL_SIZE
    var ypos = pos.y * TOTAL_CELL_SIZE + WALL_SIZE
    var cell = _grid_get(pos)
    var floortype = _boxes[cell].floortype
    if cell >= 0:
        # Draw the contents of the room
        for i in range(CELL_SIZE):
            for j in range(CELL_SIZE):
                _room.set_tile_cell(Vector2(xpos + i, ypos + j), floortype)
        # Now draw the walls
        # Top Wall
        for i in range(CELL_SIZE):
            if _grid_get(pos + Vector2(0, -1)) == cell:
                _room.set_tile_cell(Vector2(xpos + i, ypos - 1), floortype)
            else:
                _room.set_tile_cell(Vector2(xpos + i, ypos - 1), _room.Tile.DebugWall)
        # Bottom Wall
        for i in range(CELL_SIZE):
            if _grid_get(pos + Vector2(0, 1)) == cell:
                _room.set_tile_cell(Vector2(xpos + i, ypos + CELL_SIZE), floortype)
            else:
                _room.set_tile_cell(Vector2(xpos + i, ypos + CELL_SIZE), _room.Tile.DebugWall)
        # Left Wall
        for i in range(CELL_SIZE):
            if _grid_get(pos + Vector2(-1, 0)) == cell:
                _room.set_tile_cell(Vector2(xpos - 1, ypos + i), floortype)
            else:
                _room.set_tile_cell(Vector2(xpos - 1, ypos + i), _room.Tile.DebugWall)
        # Right Wall
        for i in range(CELL_SIZE):
            if _grid_get(pos + Vector2(1, 0)) == cell:
                _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos + i), floortype)
            else:
                _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos + i), _room.Tile.DebugWall)
        # Upper Left Wall
        if _grid_get(pos + Vector2(-1, 0)) == cell and _grid_get(pos + Vector2(0, -1)) == cell and _grid_get(pos + Vector2(-1, -1)) == cell:
            _room.set_tile_cell(Vector2(xpos - 1, ypos - 1), floortype)
        else:
            _room.set_tile_cell(Vector2(xpos - 1, ypos - 1), _room.Tile.DebugWall)
        # Upper Right Wall
        if _grid_get(pos + Vector2(1, 0)) == cell and _grid_get(pos + Vector2(0, -1)) == cell and _grid_get(pos + Vector2(1, -1)) == cell:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos - 1), floortype)
        else:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos - 1), _room.Tile.DebugWall)
        # Lower Left Wall
        if _grid_get(pos + Vector2(-1, 0)) == cell and _grid_get(pos + Vector2(0, 1)) == cell and _grid_get(pos + Vector2(-1, 1)) == cell:
            _room.set_tile_cell(Vector2(xpos - 1, ypos + CELL_SIZE), floortype)
        else:
            _room.set_tile_cell(Vector2(xpos - 1, ypos + CELL_SIZE), _room.Tile.DebugWall)
        # Lower Right Wall
        if _grid_get(pos + Vector2(1, 0)) == cell and _grid_get(pos + Vector2(0, 1)) == cell and _grid_get(pos + Vector2(1, 1)) == cell:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos + CELL_SIZE), floortype)
        else:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos + CELL_SIZE), _room.Tile.DebugWall)

func _open_doorways() -> void:
    # Assumes all connections are of the form [a, b] where b is either
    # strictly one to the right or strictly one below a.
    for conn in _connections:
        var a = conn.pos[0]
        var b = conn.pos[1]
        var floora = _boxes[_grid_get(a)].floortype
        var floorb = _boxes[_grid_get(b)].floortype
        var xpos = b.x * TOTAL_CELL_SIZE + WALL_SIZE
        var ypos = b.y * TOTAL_CELL_SIZE + WALL_SIZE
        if b - a == Vector2(0, 1):
            _room.set_tile_cell(Vector2(xpos + 1, ypos - 1), floorb)
            _room.set_tile_cell(Vector2(xpos + 2, ypos - 1), floorb)
            _room.set_tile_cell(Vector2(xpos + 1, ypos - 2), floora)
            _room.set_tile_cell(Vector2(xpos + 2, ypos - 2), floora)
        elif b - a == Vector2(1, 0):
            _room.set_tile_cell(Vector2(xpos - 1, ypos + 1), floorb)
            _room.set_tile_cell(Vector2(xpos - 1, ypos + 2), floorb)
            _room.set_tile_cell(Vector2(xpos - 2, ypos + 1), floora)
            _room.set_tile_cell(Vector2(xpos - 2, ypos + 2), floora)

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

func _connect_rooms() -> void:
    var graph = _produce_adjacency_graph()
    var total_nodes = len(graph.adja.keys())
    var visited = [_grid_get(Vector2(0, 0))]
    var edges = []
    for es in graph.adja.values():
        for e in es:
            edges.append(e)
    edges.shuffle()
    var edge_count = len(edges)
    while len(visited) < total_nodes:
        var i = 0
        while i < edge_count:
            var edge = edges[i]
            var a = _grid_get(edge.pos[0])
            var b = _grid_get(edge.pos[1])
            if visited.has(a) != visited.has(b):
                _connections.append(edge)
                if not visited.has(a):
                    visited.append(a)
                if not visited.has(b):
                    visited.append(b)
                edge_count -= 1
                edges[i] = edges[edge_count]
                edges[edge_count] = edge
            else:
                i += 1
    for i in range(edge_count):
        # Add 10% of the extras back
        var edge = edges[i]
        if randf() < 0.05:
            _connections.append(edge)

func _determine_room_properties() -> void:
    for v in _boxes.values():
        if v is RoomData:
            v.type = RoomTypes.decide_room_type(v.box.size)
            v.floortype = RoomTypes.decide_floor_type(v.type)
        else:
            v.floortype = RoomTypes.decide_floor_type(RoomTypes.RT.Hallway)

func _grid_to_room() -> void:
    var w = _data['config']['width']
    var h = _data['config']['height']
    for x in range(w):
        for y in range(h):
            _draw_base_room(Vector2(x, y))
    _open_doorways()

func generate() -> Room:
    var w = _data['config']['width']
    var h = _data['config']['height']
    _room = RoomScene.instance()
    _boxes = {}
    _connections = []
    _produce_grid_array()
    _produce_hallways()
    var id = _produce_live_rooms()
    _produce_dead_rooms(id)
    _connect_rooms()
    _determine_room_properties()
    _grid_to_room()
    _room.get_minimap().initialize(Vector2(w, h), _grid, _boxes, _connections)
    print(_grid)
    #for i in range(_data['config']['width']):
    #    for j in range(_data['config']['height']):
    #        _room.set_tile_cell(Vector2(i, j), _room.Tile.DebugFloor)
    var player = PlayerScene.instance()
    _add_entity(Vector2(1, 1), player)
    return _room
