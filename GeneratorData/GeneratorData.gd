extends Node
class_name GeneratorData

class HallwayData:
    var id: int
    var data: Array
    var connections: Array
    var floortype: int
    var walltype: int
    var edgetype
    var specialtype
    func _init(id: int, data: Array):
        self.id = id
        self.data = data
        self.connections = []
        self.floortype = RoomTypes.Tile.EmptyTile
        self.walltype = RoomTypes.Tile.DebugWall
        self.edgetype = null
        self.specialtype = null

class RoomData:
    var id: int
    var box: Rect2
    var connections: Array
    var type: int
    var floortype: int
    var walltype: int
    var edgetype
    var specialtype
    func _init(id: int, box: Rect2):
        self.id = id
        self.box = box
        self.connections = []
        self.type = -1 # Unset to begin with; we'll set it later
        self.floortype = RoomTypes.Tile.EmptyTile
        self.walltype = RoomTypes.Tile.DebugWall
        self.edgetype = null
        self.specialtype = null

class Graph:
    var adja: Dictionary = {}

const ID_OOB = -3
const ID_DEAD = -2
const ID_EMPTY = -1
const ID_HALLS = 0
const ID_ROOMS = 256

const FLAG_EDGE_FURNITURE = 0

const CELL_SIZE = 4
const WALL_SIZE = 1
const TOTAL_CELL_SIZE = CELL_SIZE + WALL_SIZE * 2

# Two special furniture placement values. PLACEMENT_INVALID will
# always register as an invalid placement and will forbid that
# placement rule from triggering. PLACEMENT_SAFE, conversely, will
# always register as safe and moves the responsibility of safety
# checking from the generator to the placement rule itself.
const PLACEMENT_INVALID = Rect2(-65536, -65536, 1, 1)
const PLACEMENT_SAFE = Rect2(-65536, -65536, 2, 2)

func _ready():
    pass
