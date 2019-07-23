extends Node
class_name GeneratorData

class HallwayData:
    var id: int
    var data: Array
    var connections: Array
    var floortype: int
    func _init(id: int, data: Array):
        self.id = id
        self.data = data
        self.connections = []
        self.floortype = RoomTypes.Tile.EmptyTile

class RoomData:
    var id: int
    var box: Rect2
    var connections: Array
    var type: int
    var floortype: int
    func _init(id: int, box: Rect2):
        self.id = id
        self.box = box
        self.connections = []
        self.type = -1 # Unset to begin with; we'll set it later
        self.floortype = RoomTypes.Tile.EmptyTile

class Graph:
    var adja: Dictionary = {}

const ID_OOB = -3
const ID_DEAD = -2
const ID_EMPTY = -1
const ID_HALLS = 0
const ID_ROOMS = 256

func _ready():
    pass
