extends Reference

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData

const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")

var _grid: GeneratorGrid
var _boxes: Dictionary

func _init(grid: GeneratorGrid, boxes: Dictionary):
    _grid = grid
    _boxes = boxes

func _paint_room(data: RoomData) -> void:
    for x in range(data.box.position.x, data.box.end.x):
        for y in range(data.box.position.y, data.box.end.y):
            _grid.set_value(Vector2(x, y), data.id)
    _boxes[data.id] = data

func _paint_hallway(hw: HallwayData) -> void:
    for pos in hw.data:
        _grid.set_value(pos, hw.id)
    _boxes[hw.id] = hw

func paint(obj) -> void:
    if obj is RoomData:
        _paint_room(obj)
    if obj is HallwayData:
        _paint_hallway(obj)
