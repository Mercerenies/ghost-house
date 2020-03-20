extends Reference

############################
# STAGE 9 - ITEM GENERATOR #
############################

const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const GeneratorPlacementHelper = preload("res://Generator/GeneratorPlacementHelper/GeneratorPlacementHelper.gd")
const ItemCollectible = preload("res://Collectible/ItemCollectible.gd")
const HealthCollectible = preload("res://Collectible/HealthCollectible.gd")
const MoneyCollectible = preload("res://Collectible/MoneyCollectible.gd")

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData

const FLAG_EDGE_FURNITURE = GeneratorData.FLAG_EDGE_FURNITURE

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

var _data: Dictionary = {}
var _room: Room
var _helper: GeneratorPlacementHelper

var _collectibles: Array = []

func _init(room_data: Dictionary,
           room: Room,
           helper: GeneratorPlacementHelper):
    _data = room_data
    _room = room
    _helper = helper

func _init_collectibles() -> void:
    _collectibles = [
        {
            "result": HealthCollectible.new(),
            "weight": 30
        },
        {
            "result": MoneyCollectible.new(1),
            "weight": 5
        },
        {
            "result": MoneyCollectible.new(5),
            "weight": 20
        },
        {
            "result": MoneyCollectible.new(10),
            "weight": 10
        },
        {
            "result": MoneyCollectible.new(20),
            "weight": 5
        },
        {
            "result": MoneyCollectible.new(30),
            "weight": 3
        },
        {
            "result": MoneyCollectible.new(50),
            "weight": 1
        },
        {
            "result": ItemCollectible.new(ItemInstance.new(
                ItemCodex.get_item(ItemCodex.ID_Potion),
                { "status_id": StatusEffectCodex.ID_HyperEffect, "status_length": 30 }
            )),
            "weight": 10
        },
        {
            "result": ItemCollectible.new(ItemInstance.new(
                ItemCodex.get_item(ItemCodex.ID_Potion),
                { "status_id": StatusEffectCodex.ID_HyperEffect, "status_length": 60 }
            )),
            "weight": 5
        },
        {
            "result": ItemCollectible.new(ItemInstance.new(
                ItemCodex.get_item(ItemCodex.ID_Potion),
                { "status_id": StatusEffectCodex.ID_InvincibleEffect, "status_length": 15 }
            )),
            "weight": 5
        },
        {
            "result": ItemCollectible.new(ItemInstance.new(
                ItemCodex.get_item(ItemCodex.ID_Potion),
                { "status_id": StatusEffectCodex.ID_InvincibleEffect, "status_length": 30 }
            )),
            "weight": 2
        },
        {
            "result": ItemCollectible.new(ItemInstance.new(
                ItemCodex.get_item(ItemCodex.ID_Potion),
                { "status_id": StatusEffectCodex.ID_NightVisionEffect, "status_length": 30 }
            )),
            "weight": 10
        },
        {
            "result": ItemCollectible.new(ItemInstance.new(
                ItemCodex.get_item(ItemCodex.ID_Potion),
                { "status_id": StatusEffectCodex.ID_NightVisionEffect, "status_length": 60 }
            )),
            "weight": 5
        },
    ]

func _put_storage_at(furniture) -> void:

    var arr = []
    for possible in _collectibles:
        var v = possible["result"]
        if Util.intersection(v.get_tags(), furniture.get_storage_tags()):
            arr.append(possible)

    if len(arr) <= 0:
        return

    var result = Util.weighted_choose(arr)
    furniture.set_storage(result)

func _try_each_position() -> void:
    for i in range(_room.get_room_bounds().size.x):
        for j in range(_room.get_room_bounds().size.y):
            var furn = _room.get_entity_cell(Vector2(i, j))
            if furn is Furniture and not furn.vars["vanishing"] and furn.get_storage() == null:
                var chance = furn.get_storage_chance() * _data['config']['percent_storage']
                if randf() < chance:
                    _put_storage_at(furn)

func run() -> void:
    _init_collectibles()
    _try_each_position()
