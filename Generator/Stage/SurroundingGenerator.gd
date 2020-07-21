extends Reference

####################################
# STAGE 6 - SURROUNDING GENERATION #
####################################

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData
const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const Connection = preload("res://Generator/Connection/Connection.gd")
const Graph = preload("res://Generator/Graph/Graph.gd")

const VAR_PLAYER_COORDS = GeneratorData.VAR_PLAYER_COORDS

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

var _data: Dictionary = {}
var _room: Room
var _vars: Dictionary = {}

func _init(room_data: Dictionary, room: Room, vars: Dictionary):
    _data = room_data
    _room = room
    _vars = vars

func _place_grass():
    # Assuming a room size of 1024x600, that means that approximately
    # 32x19 tiles should be onscreen at a time. Divide by two (since
    # the player is centered) and round up generously.
    var offscreen_x = 20
    var offscreen_y = 12
    var room_width = _data["config"]["width"] * TOTAL_CELL_SIZE
    var room_height = _data["config"]["height"] * TOTAL_CELL_SIZE

    for x in range(- offscreen_x, room_width + offscreen_x):
        for y in range(- offscreen_y, room_height + offscreen_y):
            _room.set_tile_cell(Vector2(x, y), RoomTypes.Tile.GrassTile)

func run() -> void:
    _place_grass()
