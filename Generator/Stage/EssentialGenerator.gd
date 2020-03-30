extends Reference

##################################
# STAGE 10 - ESSENTIAL GENERATOR #
##################################

const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const GeneratorPlacementHelper = preload("res://Generator/GeneratorPlacementHelper/GeneratorPlacementHelper.gd")
const Connection = preload("res://Generator/Connection/Connection.gd")
const Graph = preload("res://Generator/Graph/Graph.gd")
const KeyCollectible = preload("res://Collectible/KeyCollectible.gd")
const LockedDoor = preload("res://LockedDoor/LockedDoor.gd")

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData

const VAR_PLAYER_COORDS = GeneratorData.VAR_PLAYER_COORDS

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

var _data: Dictionary = {}
var _grid: GeneratorGrid
var _boxes: Dictionary
var _room: Room
var _vars: Dictionary
var _helper: GeneratorPlacementHelper

var _all_furniture
var _graph
var _reachable
var _locked_doors
var _key_collectible

class _IncludeAllUnlockedEdges:

    static func should_include(edge) -> bool:
        return edge.get_lock() == Connection.LockType.NONE

func _init(room_data: Dictionary,
           grid: GeneratorGrid,
           boxes: Dictionary,
           room: Room,
           vars: Dictionary,
           helper: GeneratorPlacementHelper):
    _data = room_data
    _grid = grid
    _boxes = boxes
    _room = room
    _vars = vars
    _helper = helper

func _get_all_furniture() -> Array:
    var furn = {}
    for x in range(_data["config"]["width"] * TOTAL_CELL_SIZE):
        for y in range(_data["config"]["height"] * TOTAL_CELL_SIZE):
            var entity = _room.get_entity_cell(Vector2(x, y))
            if entity is Furniture:
                furn[entity] = true
    return furn.keys()

func _is_LockedDoor(entity) -> bool:
    return entity is LockedDoor

func _find_locked_doors() -> Array:
    return Util.filter(self, "_is_LockedDoor", _room.get_entities())

func _generate_reachable_dictionary() -> void:
    var player_cell = _vars[VAR_PLAYER_COORDS]
    var player_room_id = _grid.get_value(player_cell)
    _reachable = GraphUtil.find_reachable_positions(_graph, player_room_id)

func _is_furniture_valid(furniture) -> bool:

    # The room must be reachable
    var grid_cell = furniture.cell
    var gen_cell = RoomDimensions.cell_to_generator_cell(grid_cell)
    var room_id = _grid.get_value(gen_cell)
    if not _reachable[room_id]:
        return false

    # The furniture must be able to hold a key
    var storage_tags = furniture.get_storage_tags()
    var tags = _key_collectible.get_tags()
    if not Util.intersection(storage_tags, tags):
        return false

    # The furniture must not be vanishing
    if furniture.vars["vanishing"]:
        return false

    # The furniture must be reachable (extra check)
    if not GeneratorPlacementHelper.has_free_position_surrounding(_room,
                                                                  Rect2(grid_cell, furniture.dims)):
        print("Locked in (" + furniture.get_furniture_name() + ")")
        return false

    # The furniture must not be in a hallway (for minimap reasons)
    if not (_boxes[room_id] is RoomData):
        return false

    return true

func _place_keys() -> void:
    var minimap = _room.get_minimap()
    var furniture = Util.filter(self, "_is_furniture_valid", _all_furniture)
    assert(len(furniture) >= len(_locked_doors)) # TODO Actually handle this corner case correctly

    furniture.shuffle()
    for i in range(len(_locked_doors)):
        var curr = furniture[i]
        var room_id = _grid.get_value(RoomDimensions.cell_to_generator_cell(curr.cell))
        curr.set_storage(_key_collectible)
        minimap.add_icon(room_id, Icons.Index.KEY)

func run(conn: Array) -> void:
    _all_furniture = _get_all_furniture()
    _key_collectible = KeyCollectible.new(1, true)
    _graph = Connection.make_incidence_graph(_grid, _boxes.keys(), conn, _IncludeAllUnlockedEdges)

    _generate_reachable_dictionary()
    _locked_doors = _find_locked_doors()

    _place_keys()
