extends Reference

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData
const Graph = GeneratorData.Graph

const HallwayGenerator = preload("res://Generator/HallwayGenerator.gd")
const LiveRoomGenerator = preload("res://Generator/LiveRoomGenerator.gd")
const DeadRoomGenerator = preload("res://Generator/DeadRoomGenerator.gd")
const ConnectionGenerator = preload("res://Generator/ConnectionGenerator.gd")
const PropertiesGenerator = preload("res://Generator/PropertiesGenerator.gd")
const ActualizingGenerator = preload("res://Generator/ActualizingGenerator.gd")
const SpecialGenerator = preload("res://Generator/SpecialGenerator.gd")
const EdgeGenerator = preload("res://Generator/EdgeGenerator.gd")

const GeneratorGrid = preload("res://GeneratorGrid/GeneratorGrid.gd")
const GeneratorPainter = preload("res://GeneratorPainter/GeneratorPainter.gd")
const GeneratorPlacementHelper = preload("res://GeneratorPlacementHelper/GeneratorPlacementHelper.gd")

const RoomScene = preload("res://Room/Room.tscn")
const PlayerScene = preload("res://Player/Player.tscn")

const Player = preload("res://Player/Player.gd")

# _grid IDs
#   -3 - OOB
#   -2 - Empty (dead cell marker)
#   -1 - Empty
#   0 to 255 - Hallway identifier
#   256 to 2047 - Room identifier

const ID_OOB = GeneratorData.ID_OOB
const ID_DEAD = GeneratorData.ID_DEAD
const ID_EMPTY = GeneratorData.ID_EMPTY
const ID_HALLS = GeneratorData.ID_HALLS
const ID_ROOMS = GeneratorData.ID_ROOMS

const FLAG_EDGE_FURNITURE = GeneratorData.FLAG_EDGE_FURNITURE

var _data: Dictionary = {}
var _grid: GeneratorGrid = null
var _flag_grid: GeneratorGrid = null
var _room: Room = null
var _boxes: Dictionary = {}
var _connections: Array = []

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

func _init(room_data: Dictionary):
    _data = room_data

func generate() -> Room:
    var w = _data['config']['width']
    var h = _data['config']['height']

    _boxes = {}
    _room = RoomScene.instance()
    _grid = GeneratorGrid.new(w, h, ID_EMPTY, ID_OOB)
    _flag_grid = GeneratorGrid.new(w * TOTAL_CELL_SIZE, h * TOTAL_CELL_SIZE, 0, 0)

    var painter = GeneratorPainter.new(_grid, _boxes)
    var helper = GeneratorPlacementHelper.new(_data, _grid, _room)

    var hallway_generator = HallwayGenerator.new(_data, painter)
    var live_room_generator = LiveRoomGenerator.new(_data, _grid, painter)
    var dead_room_generator = DeadRoomGenerator.new(_data, _grid, painter)
    var connection_generator = ConnectionGenerator.new(_data, _grid)
    var properties_generator = PropertiesGenerator.new(_data, _boxes)
    var actualizing_generator = ActualizingGenerator.new(_data, _grid, _boxes, _room)
    var special_generator = SpecialGenerator.new(_data, _boxes, _room, helper)
    var edge_generator = EdgeGenerator.new(_data, _grid, _flag_grid, _boxes, _room, helper)

    hallway_generator.run(ID_HALLS)
    var next_id = live_room_generator.run(ID_ROOMS)
    dead_room_generator.run(next_id)
    _connections = connection_generator.run()
    properties_generator.run()
    actualizing_generator.run(_connections)
    special_generator.run()
    edge_generator.run()

    _room.get_minimap().initialize(Vector2(w, h), _grid, _boxes, _connections)

    var player = PlayerScene.instance()
    # DEBUG CODE We'll clean this up later; it's quick and dirty player placement right now
    var playercheck = false
    for i in range(100):
        for j in range(100):
            if _room.get_entity_cell(Vector2(i + 2, j + 2)) == null:
                helper.add_entity(Vector2(i + 2, j + 2), player)
                playercheck = true
                break
        if playercheck:
            break
    player.connect("player_moved", _room.get_minimap(), "update_map")

    return _room
