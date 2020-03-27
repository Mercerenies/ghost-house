extends Node2D

const GRID_CELL_SIZE = 16
const DOOR_DRAW_RADIUS = 4
const Player = preload("res://Player/Player.gd")
const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const Connection = preload("res://Generator/Connection/Connection.gd")
const ICONS_PER_ROW = 8

const COLOR_ROOM = Color(1, 1, 1, 0.25)
const COLOR_CURRENT_ROOM = Color(1, 0, 0, 0.25)
const COLOR_BOUNDARY = Color(0, 0, 0, 1)

var _dims: Vector2 = Vector2(0, 0)
var _grid: GeneratorGrid = null
var _boxes: Dictionary = {}
var _connections: Array = []
var _discovered: Dictionary = {}
var _icons: Dictionary = {}

func _ready():
    pass

func initialize(dims: Vector2, grid: GeneratorGrid, boxes: Dictionary, connections: Array) -> void:
    _dims = dims
    _grid = grid
    _boxes = boxes
    _connections = connections
    _discovered = {}
    update_map()

func _find_player() -> Vector2:
    var room = get_parent().get_parent()
    # First, check marked entities (more efficient)
    var marks = room.get_marked_entities()
    if 'player' in marks:
        return marks[Mark.PLAYER].cell
    # If not, fall back to the less efficient linear search
    for c in room.get_entities():
        if c is Player:
            return c.cell
    # Can't find the player
    return Vector2(-1, -1)

func is_initialized() -> bool:
    # Any number of these instance variables would suffice. This one
    # is just easy to check.
    return _dims.x > 0

func get_room_id_at_pos(pos: Vector2):
    if not is_initialized():
        return null
    return _grid.get_value(pos)

func update_map() -> void:
    self.update()

func discover_room(id: int) -> void:
    _discovered[id] = true
    update_map()

func room_ids() -> Array:
    return _boxes.keys()

func add_icon(room_id: int, icon_id: int) -> void:
    if not (room_id in _icons):
        _icons[room_id] = []
    _icons[room_id].append(icon_id)

# TODO A function to remove one particular icon (e.g., when the player
# collects a key)

func clear_icons(room_id: int) -> void:
    if room_id in _icons:
        _icons[room_id] = []

func get_icons(room_id: int) -> Array:
    if room_id in _icons:
        return _icons[room_id]
    return []

func get_connections_list() -> Array:
    return _connections

func _draw() -> void:
    if _grid == null:
        return
    var upperleft = Vector2(get_viewport_rect().size.x - GRID_CELL_SIZE * _dims.x, 0)
    var playerpos = _find_player()
    var playerrpos = playerpos / GeneratorData.TOTAL_CELL_SIZE
    playerrpos.x = floor(playerrpos.x)
    playerrpos.y = floor(playerrpos.y)
    var playerroom = _grid.get_value(playerrpos)
    _discovered[playerroom] = true
    # Background
    for i in range(_dims.x):
        for j in range(_dims.y):
            var cell = _grid.get_value(Vector2(i, j))
            if _discovered.has(cell):
                var color = COLOR_ROOM
                if cell == playerroom:
                    color = COLOR_CURRENT_ROOM
                draw_rect(Rect2(upperleft + Vector2(i, j) * GRID_CELL_SIZE, Vector2(1, 1) * GRID_CELL_SIZE), color, true)
    var trblack = COLOR_BOUNDARY
    # Room barriers
    for v in _boxes.values():
        if not _discovered.has(v.id):
            continue
        if v is GeneratorData.HallwayData:
            for point in v.data:
                var cellpos = point * GRID_CELL_SIZE + upperleft
                # Up
                if _grid.get_value(point + Vector2(0, -1)) != v.id:
                    draw_line(cellpos, cellpos + Vector2(GRID_CELL_SIZE, 0), trblack)
                # Left
                if _grid.get_value(point + Vector2(-1, 0)) != v.id:
                    draw_line(cellpos, cellpos + Vector2(0, GRID_CELL_SIZE), trblack)
                # Down
                if _grid.get_value(point + Vector2(0, 1)) != v.id:
                    draw_line(cellpos + Vector2(0, GRID_CELL_SIZE), cellpos + Vector2(GRID_CELL_SIZE, GRID_CELL_SIZE), trblack)
                # Right
                if _grid.get_value(point + Vector2(1, 0)) != v.id:
                    draw_line(cellpos + Vector2(GRID_CELL_SIZE, 0), cellpos + Vector2(GRID_CELL_SIZE, GRID_CELL_SIZE), trblack)
        elif v is GeneratorData.RoomData:
            var rect = v.box
            rect = Rect2(rect.position * GRID_CELL_SIZE + upperleft, rect.size * GRID_CELL_SIZE)
            draw_rect(rect, trblack, false)
    # Doors
    for c in _connections:
        var pos0 = c.get_pos0()
        var pos1 = c.get_pos1()
        var a = _grid.get_value(pos0)
        var b = _grid.get_value(pos1)
        if _discovered.has(a) or _discovered.has(b):
            var cellpos = pos0 * GRID_CELL_SIZE + upperleft
            var center = Vector2(-128, -128) # Off-screen to start with, just in case
            if (pos1 - pos0) == Vector2(1, 0):
                # warning-ignore: integer_division
                center = cellpos + Vector2(GRID_CELL_SIZE, GRID_CELL_SIZE / 2)
            elif (pos1 - pos0) == Vector2(0, 1):
                # warning-ignore: integer_division
                center = cellpos + Vector2(GRID_CELL_SIZE / 2, GRID_CELL_SIZE)
            var rect = Rect2(center - Vector2(DOOR_DRAW_RADIUS, DOOR_DRAW_RADIUS),
                             Vector2(DOOR_DRAW_RADIUS, DOOR_DRAW_RADIUS) * 2)
            match c.get_lock():
                Connection.LockType.NONE:
                    draw_rect(rect, trblack, true)
                Connection.LockType.SIMPLE_LOCK:
                    draw_rect(rect, trblack, true) # /////
    # Icons
    for v in _boxes.values():
        if not _discovered.has(v.id):
            continue
        if v is GeneratorData.RoomData:
            if not (v.id in _icons):
                continue
            var icons = _icons[v.id]
            var rect = v.box
            var screen_rect = Rect2(rect.position * GRID_CELL_SIZE + upperleft, rect.size * GRID_CELL_SIZE)
            # warning-ignore: integer_division
            var draw_pos = screen_rect.position + screen_rect.size / 2
            draw_pos -= (Vector2(6, 0) if len(icons) == 1 else Vector2(12, 0))
            draw_pos -= Vector2(0, 6) * ceil((len(icons) + 1) / 2)
            var offset = Vector2()
            for ico in icons:
                var coords = 12 * Vector2(ico % ICONS_PER_ROW, floor(ico / ICONS_PER_ROW))
                draw_texture_rect_region(Icons.Image,
                                         Rect2(draw_pos + offset, Vector2(12, 12)),
                                         Rect2(coords, Vector2(12, 12)),
                                         Color(1, 1, 1, 0.25))
                if offset.x > 0:
                    offset.x = 0
                    offset.y += 12
                else:
                    offset.x += 12

func _on_Player_player_moved(_speed: float) -> void:
    update_map()
