extends Reference

#######################################
# STAGE 8 - EDGE FURNITURE GENERATION #
#######################################

const GeneratorGrid = preload("res://GeneratorGrid/GeneratorGrid.gd")
const GeneratorPlacementHelper = preload("res://GeneratorPlacementHelper/GeneratorPlacementHelper.gd")

const FLAG_EDGE_FURNITURE = GeneratorData.FLAG_EDGE_FURNITURE

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

var _data: Dictionary = {}
var _grid: GeneratorGrid = null
var _flag_grid: GeneratorGrid = null
var _boxes: Dictionary = {}
var _room: Room
var _helper: GeneratorPlacementHelper

func _init(room_data: Dictionary,
           grid: GeneratorGrid,
           flag_grid: GeneratorGrid,
           boxes: Dictionary,
           room: Room,
           helper: GeneratorPlacementHelper):
    _data = room_data
    _grid = grid
    _flag_grid = flag_grid
    _boxes = boxes
    _room = room
    _helper = helper

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

func _fill_edges() -> void:
    var w = _data['config']['width'] * TOTAL_CELL_SIZE
    var h = _data['config']['height'] * TOTAL_CELL_SIZE
    for x in range(w):
        for y in range(h):
            var room = _boxes[_grid.get_value(Vector2(floor(x / TOTAL_CELL_SIZE), floor(y / TOTAL_CELL_SIZE)))]
            var mngr = room.edgetype
            if _flag_grid.get_flag(Vector2(x, y), FLAG_EDGE_FURNITURE):
                var direction = -1
                if _room.is_wall_at(Vector2(x - 1, y)) and not _helper.is_blocked(_room, Vector2(x + 1, y)) and not _flag_grid.get_flag(Vector2(x + 1, y), FLAG_EDGE_FURNITURE):
                    direction = 0
                elif _room.is_wall_at(Vector2(x, y - 1)) and not _helper.is_blocked(_room, Vector2(x, y + 1)) and not _flag_grid.get_flag(Vector2(x, y + 1), FLAG_EDGE_FURNITURE):
                    direction = 1
                elif _room.is_wall_at(Vector2(x + 1, y)) and not _helper.is_blocked(_room, Vector2(x - 1, y)) and not _flag_grid.get_flag(Vector2(x - 1, y), FLAG_EDGE_FURNITURE):
                    direction = 2
                elif _room.is_wall_at(Vector2(x, y + 1)) and not _helper.is_blocked(_room, Vector2(x, y - 1)) and not _flag_grid.get_flag(Vector2(x, y - 1), FLAG_EDGE_FURNITURE):
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
                        if _helper.can_put_furniture_at(_room, rect) and not _helper.is_blocking_doorway(rect):
                            _helper.add_entity(pos, obj)
                            _helper.consider_turning_evil(obj)

func run() -> void:
    _mark_safe_edge_cells()
    _fill_edges()
