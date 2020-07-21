extends Reference

###########################
# STAGE 8 - ACTUALIZATION #
###########################

const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const RoomScene = preload("res://Room/Room.tscn")

const HorizontalFloorTransition = preload("res://RoomTransition/HorizontalFloorTransition.tscn")
const VerticalFloorTransition = preload("res://RoomTransition/VerticalFloorTransition.tscn")
const Connection = preload("res://Generator/Connection/Connection.gd")
const LockedDoor = preload("res://LockedDoor/LockedDoor.tscn")
const GeneratorPlacementHelper = preload("res://Generator/GeneratorPlacementHelper/GeneratorPlacementHelper.gd")

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

var _data: Dictionary = {}
var _grid: GeneratorGrid
var _boxes: Dictionary = {}
var _connections: Array = []
var _room: Room
var _helper: GeneratorPlacementHelper

func _init(room_data: Dictionary, grid: GeneratorGrid, boxes: Dictionary, room: Room, helper: GeneratorPlacementHelper):
    _data = room_data
    _grid = grid
    _boxes = boxes
    _room = room
    _helper = helper

# TODO Use RoomDimensions here to calculate the positions of the
# transitions, for consistency (this file predates RoomDimensions so
# we didn't use it the first time around)
func _open_doorways() -> void:
    # Assumes all connections are of the form [a, b] where b is either
    # strictly one to the right or strictly one below a. (This is
    # guaranteed by the Connection class constructor)
    for conn in _connections:
        var a = conn.get_pos0()
        var b = conn.get_pos1()
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

        # Actualizing locks
        var rect = RoomDimensions.connection_rect(conn)
        match conn.get_lock():
            Connection.LockType.NONE:
                pass
            Connection.LockType.SIMPLE_LOCK:
                var door = LockedDoor.instance()
                door.set_connection(conn)
                door.set_direction(1 if b - a == Vector2(1, 0) else 0)
                _helper.add_entity(rect.position, door)

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

func _draw_outer_rim() -> void:
    var w = int(_data['config']['width'])
    var h = int(_data['config']['height'])
    for x in range(w * TOTAL_CELL_SIZE):
        _room.set_tile_cell(Vector2(x, -1), _room.Tile.DebugWall)
        _room.set_tile_cell(Vector2(x, h * TOTAL_CELL_SIZE), _room.Tile.DebugWall)

func _grid_to_room() -> void:
    var w = int(_data['config']['width'])
    var h = int(_data['config']['height'])
    for x in range(w):
        for y in range(h):
            _draw_base_room(Vector2(x, y))
    _draw_outer_rim()
    _open_doorways()

func run(conn: Array):
    _connections = conn
    _grid_to_room()
