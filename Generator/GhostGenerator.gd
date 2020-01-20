extends Reference

###############################
# STAGE 10 - GHOST GENERATION #
###############################

const GeneratorGrid = preload("res://GeneratorGrid/GeneratorGrid.gd")
const GeneratorPlacementHelper = preload("res://GeneratorPlacementHelper/GeneratorPlacementHelper.gd")

const Ghost = preload("res://Ghost/Ghost.tscn")

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData

const FLAG_EDGE_FURNITURE = GeneratorData.FLAG_EDGE_FURNITURE

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

var _data: Dictionary = {}
var _grid: GeneratorGrid = null
var _boxes: Dictionary = {}
var _room: Room
var _helper: GeneratorPlacementHelper

func _init(room_data: Dictionary,
           grid: GeneratorGrid,
           boxes: Dictionary,
           room: Room,
           helper: GeneratorPlacementHelper):
    _data = room_data
    _grid = grid
    _boxes = boxes
    _room = room
    _helper = helper

func _get_rect_from_room_id(id: int) -> Rect2:
    var room = _boxes[id]
    assert(room is RoomData)
    return Rect2(room.box.position * TOTAL_CELL_SIZE, room.box.size * TOTAL_CELL_SIZE)

func _get_valid_room_ids(excluded_room_ids: Array) -> Array:
    var arr = []
    for key in _boxes:
        if _boxes[key] is RoomData and not (key in excluded_room_ids):
            if _boxes[key].box.size.x > 1 and _boxes[key].box.size.y > 1:
                arr.append(key)
    return arr

func _place_ghosts(order: Array) -> void:
    assert(len(order) > 0)

    var index = 0
    var players = _data["puzzle"]["players"]
    for _p in players:
        var rect = _get_rect_from_room_id(order[index])
        var valid_positions = []
        var ghost = Ghost.instance()
        for i in range(rect.position.x, rect.end.x):
            for j in range(rect.position.y, rect.end.y):
                if _room.get_entity_cell(Vector2(i, j)) == null and not _room.is_wall_at(Vector2(i, j)):
                    valid_positions.append(Vector2(i, j))
        var pos = Util.choose(valid_positions)
        _helper.add_entity(pos, ghost)
        print(pos)
        index = (index + 1) % len(order)

func run(excluded_room_ids: Array) -> void:
    if not ("puzzle" in _data):
        # No puzzle supplied so don't spawn any ghosts
        return
    var ids = _get_valid_room_ids(excluded_room_ids)
    ids.shuffle()
    _place_ghosts(ids)
