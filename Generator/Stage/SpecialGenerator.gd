extends Reference

##########################################
# STAGE 7 - SPECIAL FURNITURE GENERATION #
##########################################

const GeneratorPlacementHelper = preload("res://Generator/GeneratorPlacementHelper/GeneratorPlacementHelper.gd")

var _data: Dictionary = {}
var _room: Room
var _boxes: Dictionary = {}
var _helper: GeneratorPlacementHelper

class Callback extends Reference:
    var _room
    var _helper
    var _placement

    func _init(room, helper, placement) -> void:
        _room = room
        _helper = helper
        _placement = placement

    # Returns true if successful. Frees the object and returns false
    # if not.
    func call(obj) -> bool:
        if obj == null:
            return false
        var pos = obj.position / 32
        var rect = Rect2(pos, obj.get_dims())
        if _helper.can_put_furniture_at(_room, rect):
            if _placement.can_block_doorways() or not _helper.is_blocking_doorway(rect):
                _helper.add_entity(pos, obj)
                _helper.consider_turning_evil(obj)
                return true
        obj.free()
        return false

func _init(room_data: Dictionary, boxes: Dictionary, room: Room, helper: GeneratorPlacementHelper):
    _data = room_data
    _boxes = boxes
    _room = room
    _helper = helper

func _try_to_place(room, placement) -> void:
    var positions = placement.enumerate(room)
    var valid_positions = []
    for value in positions:
        var pos = placement.value_to_position(value)
        if pos == GeneratorData.PLACEMENT_INVALID:
            # Invalid no matter what.
            continue
        if pos == GeneratorData.PLACEMENT_SAFE:
            # A return value of PLACEMENT_SAFE is the rule's promise
            # that it will handle safety considerations itself, so we
            # don't need to do anything here.
            valid_positions.append(value)
            continue
        if _helper.can_put_furniture_at(_room, pos):
            if placement.can_block_doorways() or not _helper.is_blocking_doorway(pos):
                valid_positions.append(value)
    if len(valid_positions) == 0:
        return
    var chosen = valid_positions[randi() % len(valid_positions)]
    var callback = Callback.new(_room, _helper, placement)
    placement.spawn_at(room, chosen, callback)

func _fill_special() -> void:
    for k in _boxes:
        var v = _boxes[k]
        for spec in v.specialtype:
            _try_to_place(v, spec)

func run() -> void:
    _fill_special()
