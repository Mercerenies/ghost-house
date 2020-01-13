extends Reference

##########################################
# STAGE 7 - SPECIAL FURNITURE GENERATION #
##########################################

const GeneratorPlacementHelper = preload("res://GeneratorPlacementHelper/GeneratorPlacementHelper.gd")

var _data: Dictionary = {}
var _room: Room
var _boxes: Dictionary = {}
var _helper: GeneratorPlacementHelper

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
    # The returned values can be either objects (likely Furniture subclasses) or
    # dictionaries { "object": obj, "position": pos }. Obviously, the latter is
    # preferable if returning more than one object. If position is not specified,
    # the value_to_position will be used.
    var arr = placement.spawn_at(room, chosen)
    if not (arr is Array):
        arr = [arr]
    for obj in arr:
        # This bit of redundancy is necessary for
        # PLACEMENT_SAFE-style rules.
        var pos
        if obj is Dictionary:
            pos = obj['position']
            obj = obj['object']
        elif obj != null:
            pos = obj.position / 32
        if obj == null:
            continue
        var rect = Rect2(pos, obj.get_dims())
        if _helper.can_put_furniture_at(_room, rect):
            if placement.can_block_doorways() or not _helper.is_blocking_doorway(rect):
                _helper.add_entity(pos, obj)
                _helper.consider_turning_evil(obj)
                continue
        # If we couldn't place it, free it.
        obj.free()

func _fill_special() -> void:
    for k in _boxes:
        var v = _boxes[k]
        for spec in v.specialtype:
            _try_to_place(v, spec)

func run() -> void:
    _fill_special()
