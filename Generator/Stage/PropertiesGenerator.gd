extends Reference

###################################
# STAGE 5 - PROPERTIES GENERATION #
###################################

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData

const VAR_OUTER_WALLS = GeneratorData.VAR_OUTER_WALLS
const Tile = RoomTypes.Tile

var _data: Dictionary = {}
var _boxes: Dictionary = {}
var _vars: Dictionary = {}

var outer_wall_types: Array = [Tile.BrickWall1, Tile.BrickWall2, Tile.BrickWall3, Tile.Siding1, Tile.Siding2, Tile.Siding3]

func _init(room_data: Dictionary, boxes: Dictionary, vars: Dictionary):
    _data = room_data
    _boxes = boxes
    _vars = vars

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

func _determine_outer_properties() -> void:
    var arr = outer_wall_types
    _vars[VAR_OUTER_WALLS] = arr[randi() % len(arr)]

func run() -> void:
    _determine_room_properties()
    _determine_outer_properties()
