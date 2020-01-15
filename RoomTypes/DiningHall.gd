extends Node

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

#const CircularDiningTablePlacement = preload("res://Furniture/CircularDiningTable/CircularDiningTablePlacement.gd")
const DiningTable = preload("res://Furniture/DiningTable/DiningTable.tscn")
const DiningChair = preload("res://Furniture/DiningChair/DiningChair.tscn")

class _Helper:

    static func _make_chair_facing(pos: Vector2, dir: int):
        var chair = DiningChair.instance()
        chair.position = pos * 32
        chair.set_direction(dir)
        return chair

class _SurroundedInChairsCallback extends Reference:
    var _inner
    var _check

    func _init(inner):
        _inner = inner
        _check = true

    func has_failed() -> bool:
        # This helper monitors whether it has failed a placement yet
        # or not. If it has, this function returns true
        return !_check

    func call(obj) -> bool:
        var res = _inner.call(obj)
        _check = _check and res
        return _check

# For the below two, the position is the upper-left corner of the
# table, NOT of the full bounding box (the latter includes the chairs)

class HorizontalLongRow extends Reference:
    var _rate: float
    var _width: float
    var _max_len: int

    func _init(rate: float, width: int, max_len: int) -> void:
        _rate = rate
        _width = width
        _max_len = max_len

    func spawn_at_position(room, pos, cb):
        var length = min(room.box.size.x * TOTAL_CELL_SIZE, _max_len)
        var table
        while length > 3:
            table = DiningTable.instance()
            table.set_dims(Vector2(length, _width))
            table.position = 32 * pos
            if cb.call(table):
                # Success
                break
            length -= 1
        if length <= 3:
            return # Too small
        # Put chairs above and below
        for i in range(length):
            # Top
            if randf() < _rate:
                cb.call(_Helper._make_chair_facing(pos + Vector2(i, -1), 1))
            # Bottom
            if randf() < _rate:
                cb.call(_Helper._make_chair_facing(pos + Vector2(i, _width), 3))

class VerticalLongRow extends Reference:
    var _rate: float
    var _width: float
    var _max_len: int

    func _init(rate: float, width: int, max_len: int) -> void:
        _rate = rate
        _width = width
        _max_len = max_len

    func spawn_at_position(room, pos, cb):
        var length = min(room.box.size.y * TOTAL_CELL_SIZE, _max_len)
        var table
        while length > 3:
            table = DiningTable.instance()
            table.set_dims(Vector2(_width, length))
            table.position = 32 * pos
            if cb.call(table):
                # Success
                break
            length -= 1
        if length <= 3:
            return # Too small
        # Put chairs left and right
        for i in range(length):
            # Left
            if randf() < _rate:
                cb.call(_Helper._make_chair_facing(pos + Vector2(-1, i), 0))
            # Right
            if randf() < _rate:
                cb.call(_Helper._make_chair_facing(pos + Vector2(_width, i), 2))

class PlacementManager extends SpecialPlacementManager:

    func determine_placements(size: Vector2) -> Array:
        return []
