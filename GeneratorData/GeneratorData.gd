extends Node
class_name GeneratorData

class HallwayData:
    var id: int
    var data: Array
    var connections: Array
    var floortype: int
    var walltype: int
    var edgetype
    func _init(id: int, data: Array):
        self.id = id
        self.data = data
        self.connections = []
        self.floortype = RoomTypes.Tile.EmptyTile
        self.walltype = RoomTypes.Tile.DebugWall
        self.edgetype = null

class RoomData:
    var id: int
    var box: Rect2
    var connections: Array
    var type: int
    var floortype: int
    var walltype: int
    var edgetype
    func _init(id: int, box: Rect2):
        self.id = id
        self.box = box
        self.connections = []
        self.type = -1 # Unset to begin with; we'll set it later
        self.floortype = RoomTypes.Tile.EmptyTile
        self.walltype = RoomTypes.Tile.DebugWall
        self.edgetype = null

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

func _ready():
    pass
