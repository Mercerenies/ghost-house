extends Reference

############################
# STAGE 9 - ITEM GENERATOR #
############################

const GeneratorGrid = preload("res://GeneratorGrid/GeneratorGrid.gd")
const GeneratorPlacementHelper = preload("res://GeneratorPlacementHelper/GeneratorPlacementHelper.gd")
const ItemCollectible = preload("res://Collectible/ItemCollectible.gd")
const HealthCollectible = preload("res://Collectible/HealthCollectible.gd")

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData

const FLAG_EDGE_FURNITURE = GeneratorData.FLAG_EDGE_FURNITURE

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

var _data: Dictionary = {}
var _room: Room
var _helper: GeneratorPlacementHelper

func _init(room_data: Dictionary,
           room: Room,
           helper: GeneratorPlacementHelper):
    _data = room_data
    _room = room
    _helper = helper

func run() -> void:
    # Definitely DEBUG CODE
    for i in range(_room.get_room_bounds().size.x):
        for j in range(_room.get_room_bounds().size.y):
            var furn = _room.get_entity_cell(Vector2(i, j))
            if furn is Furniture:
                #furn.set_storage(ItemCollectible.new(ItemInstance.new(ItemCodex.get_item(ItemCodex.ID_DebugItem), null)))
                furn.set_storage(HealthCollectible.new())

                # ///// Make this actually smart and put the right things in the right places
