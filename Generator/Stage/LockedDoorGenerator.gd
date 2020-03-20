extends Reference

####################################
# STAGE 6 - LOCKED DOOR GENERATION #
####################################

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData

var _data: Dictionary = {}
var _boxes: Dictionary = {}

func _init(room_data: Dictionary, boxes: Dictionary):
    _data = room_data
    _boxes = boxes

func run(conn: Array) -> void:
    pass
