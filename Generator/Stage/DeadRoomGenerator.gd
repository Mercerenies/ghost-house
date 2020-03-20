extends Reference

##################################
# STAGE 3 - DEAD ROOM GENERATION #
##################################

const RoomData = GeneratorData.RoomData

const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const GeneratorPainter = preload("res://Generator/GeneratorPainter/GeneratorPainter.gd")

const ID_OOB = GeneratorData.ID_OOB
const ID_DEAD = GeneratorData.ID_DEAD
const ID_EMPTY = GeneratorData.ID_EMPTY
const ID_HALLS = GeneratorData.ID_HALLS
const ID_ROOMS = GeneratorData.ID_ROOMS

var _data: Dictionary = {}
var _grid: GeneratorGrid = null
var _painter: GeneratorPainter = null

func _init(room_data: Dictionary, grid: GeneratorGrid, painter: GeneratorPainter):
    _data = room_data
    _grid = grid
    _painter = painter

func _produce_dead_rooms(start_id: int) -> int:
    var current_id = start_id
    var w = int(_data['config']['width'])
    var h = int(_data['config']['height'])

    for x in range(w):
        for y in range(h):
            if _grid.get_value(Vector2(x, y)) < ID_HALLS and not _grid.get_value(Vector2(x, y)) == ID_OOB:
                if randf() < 0.5:
                    # Expand to the right
                    var ww = 1
                    while ww < 4 and _grid.get_value(Vector2(x + ww, y)) < ID_HALLS and not _grid.get_value(Vector2(x + ww, y)) == ID_OOB:
                        ww += 1
                    _painter.paint(RoomData.new(current_id, Rect2(x, y, ww, 1)))
                else:
                    # Expand to the bottom
                    var hh = 1
                    while hh < 4 and _grid.get_value(Vector2(x, y + hh)) < ID_HALLS and not _grid.get_value(Vector2(x, y + hh)) == ID_OOB:
                        hh += 1
                    _painter.paint(RoomData.new(current_id, Rect2(x, y, 1, hh)))
                current_id += 1

    return current_id

func run(start_id: int) -> int:
    return _produce_dead_rooms(start_id)
