extends Reference

###############################
# STAGE 10 - GHOST GENERATION #
###############################

const GeneratorGrid = preload("res://GeneratorGrid/GeneratorGrid.gd")
const GeneratorPlacementHelper = preload("res://GeneratorPlacementHelper/GeneratorPlacementHelper.gd")
const GhostNamer = preload("res://GhostNamer/GhostNamer.gd")

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
var _ghost_info: Dictionary

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
    _ghost_info = {}

func _make_ghost_info() -> void:
    var namer = GhostNamer.new()
    var players = _data["puzzle"]["players"]
    for p in players:
        var gender = randi() % 2
        var color = Util.choose(GhostColors.color_constants())
        var generated = namer.generate_name(gender)
        var info = GhostInfo.new()
        info.icon_index = generated["index"]
        info.ghost_name = generated["name"]
        info.gender = gender
        info.color = color
        _ghost_info[p] = info

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

func _get_ghost_name(id: String) -> String:
    assert(id in _ghost_info)
    return _ghost_info[id].ghost_name

func _place_ghosts(order: Array) -> void:
    assert(len(order) > 0)

    var minimap = _room.get_minimap()

    var index = 0
    var players = _data["puzzle"]["players"]
    for key in players:
        var rect = _get_rect_from_room_id(order[index])
        var valid_positions = []
        var ghost = Ghost.instance()

        for i in range(rect.position.x, rect.end.x):
            for j in range(rect.position.y, rect.end.y):
                if _room.get_entity_cell(Vector2(i, j)) == null and not _room.is_wall_at(Vector2(i, j)):
                    valid_positions.append(Vector2(i, j))
        var pos = Util.choose(valid_positions)
        _helper.add_entity(pos, ghost)

        var clue = players[key]["statement"]
        ghost.set_clue(StatementPrinter.batch_rename(clue, self, "_get_ghost_name"))

        minimap.add_icon(order[index], Icons.Index.FIRST_GHOST + _ghost_info[key].icon_index)
        ghost.set_name(_ghost_info[key].ghost_name)
        ghost.set_key(key)
        ghost.texture = GhostNamer.gender_to_image(_ghost_info[key].gender)
        ghost.color = GhostColors.color_constant_to_color(_ghost_info[key].color)

        index = (index + 1) % len(order)

func _inform_room() -> void:
    var ghost_database = _room.get_ghost_database()
    ghost_database.set_ghost_info(_ghost_info)
    ghost_database.set_ghost_data(_data["puzzle"]["players"])

func run(excluded_room_ids: Array) -> void:
    if not ("puzzle" in _data):
        # No puzzle supplied so don't spawn any ghosts
        return
    _make_ghost_info()
    var ids = _get_valid_room_ids(excluded_room_ids)
    ids.shuffle()
    _place_ghosts(ids)
    _inform_room()
