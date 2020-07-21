extends Reference

######################################
# STAGE 13 - AMBIENT ENEMY GENERATOR #
######################################

const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const GeneratorPlacementHelper = preload("res://Generator/GeneratorPlacementHelper/GeneratorPlacementHelper.gd")
const GhostNamer = preload("res://GhostNamer/GhostNamer.gd")

const FakeGhost = preload("res://FakeGhost/FakeGhost.tscn")
const ShadowStalker = preload("res://ShadowStalker/ShadowStalker.tscn")

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData

const FLAG_EDGE_FURNITURE = GeneratorData.FLAG_EDGE_FURNITURE

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

var _data: Dictionary = {}
var _helper: GeneratorPlacementHelper

func _init(room_data: Dictionary,
           helper: GeneratorPlacementHelper):
    _data = room_data
    _helper = helper

func _determine_enemy_types() -> Array:
    # Right now, this function is trivial. As we make the
    # ambient_enemies option more flexible, this will do more work.
    return _data["ambient_enemies"]

func _spawn_enemy(type: String) -> void:
    match type:
        "fake_ghost":
            var fake_ghost = FakeGhost.instance()
            # Actual position is irrelevant (the ghost will move
            # itself immediately anyway); I just don't want it
            # onscreen.
            _helper.add_entity(Vector2(-1280, -1280), fake_ghost)
        "shadow_stalker":
            var shadow_stalker = ShadowStalker.instance()
            _helper.add_entity(Vector2(-1280, -1280), shadow_stalker)
        _:
            assert(false) # Invalid enemy type to spawn

func run() -> void:
    if not ("ambient_enemies" in _data):
        # No enemy spec supplied so don't spawn any ambient enemies
        return
    var arr = _determine_enemy_types()
    for enemy_type in arr:
        _spawn_enemy(enemy_type)
