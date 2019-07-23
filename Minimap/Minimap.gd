extends Node2D

const GRID_CELL_SIZE = 16
const DOOR_DRAW_RADIUS = 4

var _dims: Vector2 = Vector2(0, 0)
var _grid: Array = []
var _boxes: Dictionary = {}
var _connections: Array = []

func _ready():
    pass

func _grid_get(pos: Vector2) -> int:
    var w = _dims.x
    var h = _dims.y
    if pos.x < 0 or pos.y < 0 or pos.x >= w or pos.y >= h:
        return GeneratorData.ID_OOB
    return _grid[pos.y + pos.x * h]

func _grid_set(pos: Vector2, value: int) -> void:
    var h = _dims.y
    _grid[pos.y + pos.x * h] = value

func initialize(dims: Vector2, grid: Array, boxes: Dictionary, connections: Array) -> void:
    _dims = dims
    _grid = grid
    _boxes = boxes
    _connections = connections

func _draw() -> void:
    var upperleft = Vector2(get_viewport_rect().size.x - GRID_CELL_SIZE * _dims.x, 0)
    draw_rect(Rect2(upperleft, _dims * GRID_CELL_SIZE), Color(1, 1, 1, 0.25), true)
    var trblack = Color(0, 0, 0, 1)
    # Room barriers
    for v in _boxes.values():
        if v is GeneratorData.HallwayData:
            for point in v.data:
                var cellpos = point * GRID_CELL_SIZE + upperleft
                # Up
                if _grid_get(point + Vector2(0, -1)) != v.id:
                    draw_line(cellpos, cellpos + Vector2(GRID_CELL_SIZE, 0), trblack)
                # Left
                if _grid_get(point + Vector2(-1, 0)) != v.id:
                    draw_line(cellpos, cellpos + Vector2(0, GRID_CELL_SIZE), trblack)
                # Down
                if _grid_get(point + Vector2(0, 1)) != v.id:
                    draw_line(cellpos + Vector2(0, GRID_CELL_SIZE), cellpos + Vector2(GRID_CELL_SIZE, GRID_CELL_SIZE), trblack)
                # Right
                if _grid_get(point + Vector2(1, 0)) != v.id:
                    draw_line(cellpos + Vector2(GRID_CELL_SIZE, 0), cellpos + Vector2(GRID_CELL_SIZE, GRID_CELL_SIZE), trblack)
        elif v is GeneratorData.RoomData:
            var rect = v.box
            rect = Rect2(rect.position * GRID_CELL_SIZE + upperleft, rect.size * GRID_CELL_SIZE)
            draw_rect(rect, trblack, false)
    # Doors
    for c in _connections:
        var pos = c.pos
        var cellpos = pos[0] * GRID_CELL_SIZE + upperleft
        var center = Vector2(-128, -128) # Off-screen to start with, just in case
        if pos[1] - pos[0] == Vector2(1, 0):
            center = cellpos + Vector2(GRID_CELL_SIZE, GRID_CELL_SIZE / 2)
        elif pos[1] - pos[0] == Vector2(0, 1):
            center = cellpos + Vector2(GRID_CELL_SIZE / 2, GRID_CELL_SIZE)
        draw_rect(Rect2(center - Vector2(DOOR_DRAW_RADIUS, DOOR_DRAW_RADIUS),
                        Vector2(DOOR_DRAW_RADIUS, DOOR_DRAW_RADIUS) * 2),
                  trblack,
                  true)