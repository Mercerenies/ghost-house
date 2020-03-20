extends Reference

####################################
# STAGE 6 - LOCKED DOOR GENERATION #
####################################

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData
const Connection = preload("res://Generator/Connection/Connection.gd")


var _data: Dictionary = {}
var _boxes: Dictionary = {}

func _init(room_data: Dictionary, boxes: Dictionary):
    _data = room_data
    _boxes = boxes

func run(conn: Array) -> void:
    pass
    # DEBUG CODE
    #for c in conn:
    #    c.set_lock(Connection.LockType.SIMPLE_LOCK)
