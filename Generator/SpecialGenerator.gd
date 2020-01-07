extends Reference

##########################################
# STAGE 6 - SPECIAL FURNITURE GENERATION #
##########################################

const GeneratorPlacementHelper = preload("res://GeneratorPlacementHelper/GeneratorPlacementHelper.gd")

var _data: Dictionary = {}
var _boxes: Dictionary = {}
var _helper: GeneratorPlacementHelper

func _init(room_data: Dictionary, boxes: Dictionary, helper: GeneratorPlacementHelper):
    _data = room_data
    _boxes = boxes
    _helper = helper

func _try_to_place(room, placement) -> void:
    var positions = placement.enumerate(room)
    var valid_positions = []
    for value in positions:
        var pos = placement.value_to_position(value)
        if _helper.can_put_furniture_at(pos):
            if placement.can_block_doorways() or not _helper.is_blocking_doorway(pos):
                valid_positions.append(value)
    if len(valid_positions) == 0:
        return
    var chosen = valid_positions[randi() % len(valid_positions)]
    var obj = placement.spawn_at(chosen)
    if obj != null:
        _helper.add_entity(placement.value_to_position(chosen).position, obj)
        _helper.consider_turning_evil(obj)

func _fill_special() -> void:
    for k in _boxes:
        var v = _boxes[k]
        for spec in v.specialtype:
            _try_to_place(v, spec)

func run() -> void:
    _fill_special()
