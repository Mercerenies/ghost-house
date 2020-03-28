extends Reference

##################################
# STAGE 10 - ESSENTIAL GENERATOR #
##################################

const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const GeneratorPlacementHelper = preload("res://Generator/GeneratorPlacementHelper/GeneratorPlacementHelper.gd")
const Connection = preload("res://Generator/Connection/Connection.gd")
const Graph = preload("res://Generator/Graph/Graph.gd")
const KeyCollectible = preload("res://Collectible/KeyCollectible.gd")

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

func run(conn: Array) -> void:
    var all_furniture = _get_all_furniture()
    var graph = Connection.make_incidence_graph(_grid, _boxes.keys(), conn, _IncludeAllUnlockedEdges)

    var player_cell = _vars[VAR_PLAYER_COORDS]
    var player_room_id = _grid.get_value(player_cell)
    var reachable = GraphUtil.find_reachable_positions(graph, player_room_id)

    # /////
