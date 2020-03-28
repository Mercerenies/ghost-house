extends Reference

##################################
# STAGE 10 - ESSENTIAL GENERATOR #
##################################

const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const GeneratorPlacementHelper = preload("res://Generator/GeneratorPlacementHelper/GeneratorPlacementHelper.gd")
const KeyCollectible = preload("res://Collectible/KeyCollectible.gd")

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData

const FLAG_EDGE_FURNITURE = GeneratorData.FLAG_EDGE_FURNITURE

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

var _data: Dictionary = {}
var _room: Room
var _vars: Dictionary
var _helper: GeneratorPlacementHelper

func _init(room_data: Dictionary,
           room: Room,
           vars: Dictionary,
           helper: GeneratorPlacementHelper):
    _data = room_data
    _room = room
    _vars = vars
    _helper = helper

func run(conn: Array) -> void:
    pass
