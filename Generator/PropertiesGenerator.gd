extends Reference

###################################
# STAGE 5 - PROPERTIES GENERATION #
###################################

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData

var _data: Dictionary = {}
var _boxes: Dictionary = {}

func _init(room_data: Dictionary, boxes: Dictionary):
    _data = room_data
    _boxes = boxes

func _determine_room_properties() -> void:
    for v in _boxes.values():
        if v is RoomData:
            v.type = RoomTypes.decide_room_type(v.box.size)
            v.floortype = RoomTypes.decide_floor_type(v.type)
            v.walltype = RoomTypes.decide_wall_type(v.type)
            v.edgetype = RoomTypes.decide_edge_manager(v.type)
            v.specialtype = RoomTypes.decide_special_manager(v.box.size, v.type)
        elif v is HallwayData:
            v.floortype = RoomTypes.decide_floor_type(RoomTypes.RT.Hallway)
            v.walltype = RoomTypes.decide_wall_type(RoomTypes.RT.Hallway)
            v.edgetype = RoomTypes.decide_edge_manager(RoomTypes.RT.Hallway)
            v.specialtype = RoomTypes.decide_special_manager(Vector2(), RoomTypes.RT.Hallway)
        else:
            # Welp
            pass

func run() -> void:
    _determine_room_properties()
