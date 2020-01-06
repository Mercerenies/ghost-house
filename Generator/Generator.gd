extends Reference

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData
const Graph = GeneratorData.Graph

const HallwayGenerator = preload("res://Generator/HallwayGenerator.gd")
const LiveRoomGenerator = preload("res://Generator/LiveRoomGenerator.gd")
const DeadRoomGenerator = preload("res://Generator/DeadRoomGenerator.gd")
const ConnectionGenerator = preload("res://Generator/ConnectionGenerator.gd")
const PropertiesGenerator = preload("res://Generator/PropertiesGenerator.gd")

const GeneratorGrid = preload("res://GeneratorGrid/GeneratorGrid.gd")
const GeneratorPainter = preload("res://GeneratorPainter/GeneratorPainter.gd")

const RoomScene = preload("res://Room/Room.tscn")
const PlayerScene = preload("res://Player/Player.tscn")
const HorizontalFloorTransition = preload("res://RoomTransition/HorizontalFloorTransition.tscn")
const VerticalFloorTransition = preload("res://RoomTransition/VerticalFloorTransition.tscn")

const Player = preload("res://Player/Player.gd")

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

const FLAG_EDGE_FURNITURE = GeneratorData.FLAG_EDGE_FURNITURE

var _data: Dictionary = {}
var _grid: GeneratorGrid = null
var _flag_grid: GeneratorGrid = null
var _room: Room = null
var _boxes: Dictionary = {}
var _connections: Array = []

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

func _init(room_data: Dictionary):
    _data = room_data

func _add_entity(pos: Vector2, entity: Object) -> void:
    _room.get_node("Entities").add_child(entity)
    entity.position = pos * 32
    entity.position_self()
    if entity is Player:
        _room.get_marked_entities()["player"] = entity

func _paint_room(id: int, rect: Rect2) -> void:
    for x in range(rect.position.x, rect.end.x):
        for y in range(rect.position.y, rect.end.y):
            _grid.set_value(Vector2(x, y), id)
    _boxes[id] = RoomData.new(id, rect)

func _draw_base_room(pos: Vector2) -> void:
    var xpos = pos.x * TOTAL_CELL_SIZE + WALL_SIZE
    var ypos = pos.y * TOTAL_CELL_SIZE + WALL_SIZE
    var cell = _grid.get_value(pos)
    var floortype = _boxes[cell].floortype
    var walltype = _boxes[cell].walltype
    if cell >= 0:
        # Draw the contents of the room
        for i in range(CELL_SIZE):
            for j in range(CELL_SIZE):
                _room.set_tile_cell(Vector2(xpos + i, ypos + j), floortype)
        # Now draw the walls
        # Top Wall
        for i in range(CELL_SIZE):
            if _grid.get_value(pos + Vector2(0, -1)) == cell:
                _room.set_tile_cell(Vector2(xpos + i, ypos - 1), floortype)
            else:
                _room.set_tile_cell(Vector2(xpos + i, ypos - 1), walltype)
        # Bottom Wall
        for i in range(CELL_SIZE):
            if _grid.get_value(pos + Vector2(0, 1)) == cell:
                _room.set_tile_cell(Vector2(xpos + i, ypos + CELL_SIZE), floortype)
            else:
                _room.set_tile_cell(Vector2(xpos + i, ypos + CELL_SIZE), _room.Tile.DebugWall)
        # Left Wall
        for i in range(CELL_SIZE):
            if _grid.get_value(pos + Vector2(-1, 0)) == cell:
                _room.set_tile_cell(Vector2(xpos - 1, ypos + i), floortype)
            else:
                _room.set_tile_cell(Vector2(xpos - 1, ypos + i), _room.Tile.DebugWall)
        # Right Wall
        for i in range(CELL_SIZE):
            if _grid.get_value(pos + Vector2(1, 0)) == cell:
                _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos + i), floortype)
            else:
                _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos + i), _room.Tile.DebugWall)
        # Upper Left Wall
        if _grid.get_value(pos + Vector2(-1, 0)) == cell and _grid.get_value(pos + Vector2(0, -1)) == cell and _grid.get_value(pos + Vector2(-1, -1)) == cell:
            _room.set_tile_cell(Vector2(xpos - 1, ypos - 1), floortype)
        elif _grid.get_value(pos + Vector2(-1, 0)) != cell:
            _room.set_tile_cell(Vector2(xpos - 1, ypos - 1), _room.Tile.DebugWall)
        else:
            _room.set_tile_cell(Vector2(xpos - 1, ypos - 1), walltype)
        # Upper Right Wall
        if _grid.get_value(pos + Vector2(1, 0)) == cell and _grid.get_value(pos + Vector2(0, -1)) == cell and _grid.get_value(pos + Vector2(1, -1)) == cell:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos - 1), floortype)
        elif _grid.get_value(pos + Vector2(1, 0)) != cell:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos - 1), _room.Tile.DebugWall)
        else:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos - 1), walltype)
        # Lower Left Wall
        if _grid.get_value(pos + Vector2(-1, 0)) == cell and _grid.get_value(pos + Vector2(0, 1)) == cell and _grid.get_value(pos + Vector2(-1, 1)) == cell:
            _room.set_tile_cell(Vector2(xpos - 1, ypos + CELL_SIZE), floortype)
        else:
            _room.set_tile_cell(Vector2(xpos - 1, ypos + CELL_SIZE), _room.Tile.DebugWall)
        # Lower Right Wall
        if _grid.get_value(pos + Vector2(1, 0)) == cell and _grid.get_value(pos + Vector2(0, 1)) == cell and _grid.get_value(pos + Vector2(1, 1)) == cell:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos + CELL_SIZE), floortype)
        else:
            _room.set_tile_cell(Vector2(xpos + CELL_SIZE, ypos + CELL_SIZE), _room.Tile.DebugWall)

func _mark_safe_edge_cells() -> void:
    var w = _data['config']['width'] * TOTAL_CELL_SIZE
    var h = _data['config']['height'] * TOTAL_CELL_SIZE
    # Find non-corner walls
    for x in range(w):
        for y in range(h):
            if _room.is_wall_at(Vector2(x, y)):
                continue
            var walled = (int(_room.is_wall_at(Vector2(x + 1, y))) + int(_room.is_wall_at(Vector2(x, y + 1))) +
                          int(_room.is_wall_at(Vector2(x - 1, y))) + int(_room.is_wall_at(Vector2(x, y - 1))))
            if walled == 1:
                _flag_grid.set_flag(Vector2(x, y), FLAG_EDGE_FURNITURE, true)
    # Conditionally add back in the corners
    for x in range(w):
        for y in range(h):
            if _room.is_wall_at(Vector2(x, y)) or _flag_grid.get_flag(Vector2(x, y), FLAG_EDGE_FURNITURE):
                continue
            var walled = (int(_room.is_wall_at(Vector2(x + 1, y))) + int(_room.is_wall_at(Vector2(x, y + 1))) +
                          int(_room.is_wall_at(Vector2(x - 1, y))) + int(_room.is_wall_at(Vector2(x, y - 1))))
            var edged = (int(_flag_grid.get_flag(Vector2(x + 1, y), FLAG_EDGE_FURNITURE)) +
                         int(_flag_grid.get_flag(Vector2(x - 1, y), FLAG_EDGE_FURNITURE)) +
                         int(_flag_grid.get_flag(Vector2(x, y + 1), FLAG_EDGE_FURNITURE)) +
                         int(_flag_grid.get_flag(Vector2(x, y - 1), FLAG_EDGE_FURNITURE)))
            if walled == 2 and edged < 2:
                _flag_grid.set_flag(Vector2(x, y), FLAG_EDGE_FURNITURE, true)

func _open_doorways() -> void:
    # Assumes all connections are of the form [a, b] where b is either
    # strictly one to the right or strictly one below a.
    for conn in _connections:
        var a = conn.pos[0]
        var b = conn.pos[1]
        var floora = _boxes[_grid.get_value(a)].floortype
        var floorb = _boxes[_grid.get_value(b)].floortype
        var walla = _boxes[_grid.get_value(a)].walltype
        var wallb = _boxes[_grid.get_value(b)].walltype
        var xpos = b.x * TOTAL_CELL_SIZE + WALL_SIZE
        var ypos = b.y * TOTAL_CELL_SIZE + WALL_SIZE
        if b - a == Vector2(0, 1):
            _room.set_tile_cell(Vector2(xpos + 1, ypos - 1), floorb)
            _room.set_tile_cell(Vector2(xpos + 2, ypos - 1), floorb)
            _room.set_tile_cell(Vector2(xpos + 1, ypos - 2), floora)
            _room.set_tile_cell(Vector2(xpos + 2, ypos - 2), floora)
            if floora != floorb:
                var transa = VerticalFloorTransition.instance()
                var transb = VerticalFloorTransition.instance()
                transa.position = Vector2(xpos + 1, ypos - 1) * 32
                transb.position = Vector2(xpos + 2, ypos - 1) * 32
                _room.get_node("Decorations").add_child(transa)
                _room.get_node("Decorations").add_child(transb)
        elif b - a == Vector2(1, 0):
            _room.set_tile_cell(Vector2(xpos - 1, ypos + 1), floorb)
            _room.set_tile_cell(Vector2(xpos - 1, ypos + 2), floorb)
            _room.set_tile_cell(Vector2(xpos - 2, ypos + 1), floora)
            _room.set_tile_cell(Vector2(xpos - 2, ypos + 2), floora)
            _room.set_tile_cell(Vector2(xpos - 2, ypos    ), walla )
            _room.set_tile_cell(Vector2(xpos - 1, ypos    ), wallb )
            if floora != floorb:
                var transa = HorizontalFloorTransition.instance()
                var transb = HorizontalFloorTransition.instance()
                transa.position = Vector2(xpos - 1, ypos + 1) * 32
                transb.position = Vector2(xpos - 1, ypos + 2) * 32
                _room.get_node("Decorations").add_child(transa)
                _room.get_node("Decorations").add_child(transb)

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
    _open_doorways()

func is_blocked(pos: Vector2) -> bool:
    return _room.is_wall_at(pos) or _room.get_entity_cell(pos) != null

func _can_put_furniture_at(rect: Rect2) -> bool:
    # Check the position we want to put it at first
    for i in range(rect.size.x):
        for j in range(rect.size.y):
            if is_blocked(rect.position + Vector2(i, j)):
                return false
    var transitions = 0
    # Top edge
    for i in range(rect.size.x + 1):
        var pos = Vector2(rect.position.x - 1 + i, rect.position.y - 1)
        if is_blocked(pos) != is_blocked(pos + Vector2(1, 0)):
            transitions += 1
    # Right edge
    for i in range(rect.size.y + 1):
        var pos = Vector2(rect.end.x, rect.position.y - 1 + i)
        if is_blocked(pos) != is_blocked(pos + Vector2(0, 1)):
            transitions += 1
    # Bottom edge
    for i in range(rect.size.x + 1):
        var pos = Vector2(rect.end.x - i, rect.end.y)
        if is_blocked(pos) != is_blocked(pos + Vector2(-1, 0)):
            transitions += 1
    # Left edge
    for i in range(rect.size.y + 1):
        var pos = Vector2(rect.position.x - 1, rect.end.y - i)
        if is_blocked(pos) != is_blocked(pos + Vector2(0, -1)):
            transitions += 1
    return transitions <= 2

func _is_doorway_at_position(pos: Vector2) -> bool:
    if not _room.is_wall_at(pos):
        # Left edge
        var cell = Vector2(floor(pos.x / TOTAL_CELL_SIZE), floor(pos.y / TOTAL_CELL_SIZE))
        if int(pos.x) % TOTAL_CELL_SIZE == 0:
            if _grid.get_value(cell) != _grid.get_value(cell + Vector2(-1, 0)):
                return true
        # Right edge
        if int(pos.x) % TOTAL_CELL_SIZE == TOTAL_CELL_SIZE - 1:
            if _grid.get_value(cell) != _grid.get_value(cell + Vector2(1, 0)):
                return true
        # Top Edge
        if int(pos.y) % TOTAL_CELL_SIZE == 0:
            if _grid.get_value(cell) != _grid.get_value(cell + Vector2(0, -1)):
                return true
        # Bottom Edge
        if int(pos.y) % TOTAL_CELL_SIZE == TOTAL_CELL_SIZE - 1:
            if _grid.get_value(cell) != _grid.get_value(cell + Vector2(0, 1)):
                return true
    return false

func _is_blocking_doorway(rect: Rect2) -> bool:
    for i in range(rect.size.x + 2):
        for j in range(rect.size.y + 2):
            # Cut the corners
            if (i == 0 or i == rect.size.x + 1) and (j == 0 or j == rect.size.y + 1):
                continue
            # Perform the check
            if _is_doorway_at_position(rect.position + Vector2(i - 1, j - 1)):
                return true
    return false

const tmp = preload("res://Furniture/DebugLittleGreenBox/DebugLittleGreenBox.tscn")
const tmp_TwinBedPlacement = preload("res://Furniture/TwinBed/TwinBedPlacement.gd")
const tmp_KingBedPlacement = preload("res://Furniture/KingBed/KingBedPlacement.gd")
const tmp_EdgePlacementManager = preload("res://Furniture/EdgePlacementManager.gd")
const tmp_EdgeBookshelfPlacement = preload("res://Furniture/Bookshelf/EdgeBookshelfPlacement.gd")
const tmp_EdgeLongBookshelfPlacement = preload("res://Furniture/LongBookshelf/EdgeLongBookshelfPlacement.gd")

# func _debug_furniture_flood() -> void:
#     var w = _data['config']['width']
#     var h = _data['config']['height']
#     for i in range(w * TOTAL_CELL_SIZE):
#         for j in range(h * TOTAL_CELL_SIZE):
#             if _can_put_furniture_at(Rect2(i, j, 2, 2)) and not _is_blocking_doorway(Rect2(i, j, 2, 2)):
#                 var silly = tmp.instance()
#                 _add_entity(Vector2(i, j), silly)

func _consider_turning_evil(obj) -> void:
    var chance = _data['config']['percent_evil'] * obj.chance_of_turning_evil()
    if randf() < chance:
        obj.turn_evil()

func _try_to_place(room, placement) -> void:
    var positions = placement.enumerate(room)
    var valid_positions = []
    for value in positions:
        var pos = placement.value_to_position(value)
        if _can_put_furniture_at(pos):
            if placement.can_block_doorways() or not _is_blocking_doorway(pos):
                valid_positions.append(value)
    if len(valid_positions) == 0:
        return
    var chosen = valid_positions[randi() % len(valid_positions)]
    var obj = placement.spawn_at(chosen)
    if obj != null:
        _add_entity(placement.value_to_position(chosen).position, obj)
        _consider_turning_evil(obj)

func _debug_edges() -> void:
    var w = _data['config']['width'] * TOTAL_CELL_SIZE
    var h = _data['config']['height'] * TOTAL_CELL_SIZE
    for i in range(w):
        for j in range(h):
            if _flag_grid.get_flag(Vector2(i, j), FLAG_EDGE_FURNITURE) and _can_put_furniture_at(Rect2(i, j, 1, 1)) and not _is_blocking_doorway(Rect2(i, j, 1, 1)):
                 var silly = tmp.instance()
                 _add_entity(Vector2(i, j), silly)

func _fill_special() -> void:
    for k in _boxes:
        var v = _boxes[k]
        for spec in v.specialtype:
            _try_to_place(v, spec)

func _fill_edges() -> void:
    var w = _data['config']['width'] * TOTAL_CELL_SIZE
    var h = _data['config']['height'] * TOTAL_CELL_SIZE
    for x in range(w):
        for y in range(h):
            var room = _boxes[_grid.get_value(Vector2(floor(x / TOTAL_CELL_SIZE), floor(y / TOTAL_CELL_SIZE)))]
            var mngr = room.edgetype
            if _flag_grid.get_flag(Vector2(x, y), FLAG_EDGE_FURNITURE):
                var direction = -1
                if _room.is_wall_at(Vector2(x - 1, y)) and not is_blocked(Vector2(x + 1, y)) and not _flag_grid.get_flag(Vector2(x + 1, y), FLAG_EDGE_FURNITURE):
                    direction = 0
                elif _room.is_wall_at(Vector2(x, y - 1)) and not is_blocked(Vector2(x, y + 1)) and not _flag_grid.get_flag(Vector2(x, y + 1), FLAG_EDGE_FURNITURE):
                    direction = 1
                elif _room.is_wall_at(Vector2(x + 1, y)) and not is_blocked(Vector2(x - 1, y)) and not _flag_grid.get_flag(Vector2(x - 1, y), FLAG_EDGE_FURNITURE):
                    direction = 2
                elif _room.is_wall_at(Vector2(x, y + 1)) and not is_blocked(Vector2(x, y - 1)) and not _flag_grid.get_flag(Vector2(x, y - 1), FLAG_EDGE_FURNITURE):
                    direction = 3
                else:
                    continue
                var max_width = 1
                if direction % 2 == 0:
                    # Vertical expand
                    while _flag_grid.get_flag(Vector2(x, y + max_width), FLAG_EDGE_FURNITURE):
                        max_width += 1
                else:
                    # Horizontal expand
                    while _flag_grid.get_flag(Vector2(x + max_width, y), FLAG_EDGE_FURNITURE):
                        max_width += 1
                var arr = mngr.generate_at_position(Vector2(x, y), direction, max_width)
                if not (arr is Array):
                    arr = [arr]
                for obj in arr:
                    if obj != null:
                        var pos = Vector2(floor(obj.position.x / 32), floor(obj.position.y / 32))
                        var rect = Rect2(pos, obj.dims)
                        if _can_put_furniture_at(rect) and not _is_blocking_doorway(rect):
                            _add_entity(pos, obj)
                            _consider_turning_evil(obj)

func generate() -> Room:
    var w = _data['config']['width']
    var h = _data['config']['height']
    _room = RoomScene.instance()
    _boxes = {}
    _connections = []

    _grid = GeneratorGrid.new(w, h, ID_EMPTY, ID_OOB)
    _flag_grid = GeneratorGrid.new(w * TOTAL_CELL_SIZE, h * TOTAL_CELL_SIZE, 0, 0)

    var painter = GeneratorPainter.new(_grid, _boxes)

    var hallway_generator = HallwayGenerator.new(_data, painter)
    var live_room_generator = LiveRoomGenerator.new(_data, _grid, painter)
    var dead_room_generator = DeadRoomGenerator.new(_data, _grid, painter)
    var connection_generator = ConnectionGenerator.new(_data, _grid)
    var properties_generator = PropertiesGenerator.new(_data, _boxes)

    hallway_generator.run(ID_HALLS)
    var next_id = live_room_generator.run(ID_ROOMS)
    dead_room_generator.run(next_id)
    _connections = connection_generator.run()
    properties_generator.run()

    _grid_to_room()
    _mark_safe_edge_cells()
    _room.get_minimap().initialize(Vector2(w, h), _grid, _boxes, _connections)
    #print(_grid)
    _fill_special()
    _fill_edges()
    #_debug_edges()
    #for i in range(_data['config']['width']):
    #    for j in range(_data['config']['height']):
    #        _room.set_tile_cell(Vector2(i, j), _room.Tile.DebugFloor)
    var player = PlayerScene.instance()
    # DEBUG CODE We'll clean this up later; it's quick and dirty player placement right now
    var playercheck = false
    for i in range(100):
        for j in range(100):
            if _room.get_entity_cell(Vector2(i + 2, j + 2)) == null:
                _add_entity(Vector2(i + 2, j + 2), player)
                playercheck = true
                break
        if playercheck:
            break
    player.connect("player_moved", _room.get_minimap(), "update_map")
    #_debug_furniture_flood()
    return _room
