extends Reference

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData

const HallwayGenerator = preload("res://Generator/Stage/HallwayGenerator.gd")
const LiveRoomGenerator = preload("res://Generator/Stage/LiveRoomGenerator.gd")
const DeadRoomGenerator = preload("res://Generator/Stage/DeadRoomGenerator.gd")
const ConnectionGenerator = preload("res://Generator/Stage/ConnectionGenerator.gd")
const PropertiesGenerator = preload("res://Generator/Stage/PropertiesGenerator.gd")
const SurroundingGenerator = preload("res://Generator/Stage/SurroundingGenerator.gd")
const LockedDoorGenerator = preload("res://Generator/Stage/LockedDoorGenerator.gd")
const ActualizingGenerator = preload("res://Generator/Stage/ActualizingGenerator.gd")
const SpecialGenerator = preload("res://Generator/Stage/SpecialGenerator.gd")
const EdgeGenerator = preload("res://Generator/Stage/EdgeGenerator.gd")
const EssentialGenerator = preload("res://Generator/Stage/EssentialGenerator.gd")
const StorageGenerator = preload("res://Generator/Stage/StorageGenerator.gd")
const AmbientEnemyGenerator = preload("res://Generator/Stage/AmbientEnemyGenerator.gd")
const PlayerGenerator = preload("res://Generator/Stage/PlayerGenerator.gd")
const GhostGenerator = preload("res://Generator/Stage/GhostGenerator.gd")

const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const GeneratorPainter = preload("res://Generator/GeneratorPainter/GeneratorPainter.gd")
const GeneratorPlacementHelper = preload("res://Generator/GeneratorPlacementHelper/GeneratorPlacementHelper.gd")

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

const VAR_PLAYER_COORDS = GeneratorData.VAR_PLAYER_COORDS

var _data: Dictionary = {}
var _grid: GeneratorGrid = null
var _flag_grid: GeneratorGrid = null
var _room: Room = null
var _boxes: Dictionary = {}
var _connections: Array = []
var _vars: Dictionary = {}

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

func _init(room_data: Dictionary):
    _data = room_data

func generate() -> Room:
    var w = int(_data['config']['width'])
    var h = int(_data['config']['height'])

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
    var properties_generator = PropertiesGenerator.new(_data, _boxes, _vars)
    var surrounding_generator = SurroundingGenerator.new(_data, _room, _vars)
    var locked_door_generator = LockedDoorGenerator.new(_data, _grid, _boxes, _vars)
    var actualizing_generator = ActualizingGenerator.new(_data, _grid, _boxes, _room, _vars, helper)
    var special_generator = SpecialGenerator.new(_data, _boxes, _room, helper)
    var edge_generator = EdgeGenerator.new(_data, _grid, _flag_grid, _boxes, _room, helper)
    var essential_generator = EssentialGenerator.new(_data, _grid, _boxes, _room, _vars, helper)
    var storage_generator = StorageGenerator.new(_data, _room, helper)
    var ambient_enemy_generator = AmbientEnemyGenerator.new(_data, helper)
    var player_generator = PlayerGenerator.new(_data, _grid, _boxes, _room, _vars, helper)
    var ghost_generator = GhostGenerator.new(_data, _grid, _boxes, _room, helper)

    hallway_generator.run(ID_HALLS)
    var next_id = live_room_generator.run(ID_ROOMS)
    dead_room_generator.run(next_id)
    _connections = connection_generator.run()
    properties_generator.run()

    # warning-ignore: integer_division
    _vars[VAR_PLAYER_COORDS] = Vector2(floor(_grid.get_width() / 2), floor(_grid.get_height() - 1))

    surrounding_generator.run()
    locked_door_generator.run(_connections)
    actualizing_generator.run(_connections)
    special_generator.run()
    edge_generator.run()

    _room.get_minimap().initialize(Vector2(w, h), _grid, _boxes, _connections)

    essential_generator.run(_connections)
    storage_generator.run()
    ambient_enemy_generator.run()

    var player = player_generator.run()
    var player_pos = player.cell / TOTAL_CELL_SIZE
    player_pos = Vector2(floor(player_pos.x), floor(player_pos.y))
    var player_room_id = _grid.get_value(player_pos)
    ghost_generator.run([player_room_id])

    return _room
