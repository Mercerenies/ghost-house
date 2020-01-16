extends Node

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

const SimpleRows = preload("SimpleRows.gd")
const Orientation = SimpleRows.Orientation

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

    func spawn_at_position(room, pos, cb) -> int:
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
            return -1 # Too small
        # Put chairs above and below
        for i in range(length):
            # Top
            if randf() < _rate:
                cb.call(_Helper._make_chair_facing(pos + Vector2(i, -1), 1))
            # Bottom
            if randf() < _rate:
                cb.call(_Helper._make_chair_facing(pos + Vector2(i, _width), 3))
        return length

class VerticalLongRow extends Reference:
    var _rate: float
    var _width: int
    var _max_len: int

    func _init(rate: float, width: int, max_len: int) -> void:
        _rate = rate
        _width = width
        _max_len = max_len

    func spawn_at_position(room, pos, cb) -> int:
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
            return -1 # Too small
        # Put chairs left and right
        for i in range(length):
            # Left
            if randf() < _rate:
                cb.call(_Helper._make_chair_facing(pos + Vector2(-1, i), 0))
            # Right
            if randf() < _rate:
                cb.call(_Helper._make_chair_facing(pos + Vector2(_width, i), 2))
        return length

class LongRowWithBreaks extends Reference:
    var _rate: float
    var _width: int
    var _orientation: int

    func _init(rate: float, width: int, orientation: int) -> void:
        _rate = rate
        _width = width
        _orientation = orientation

    func spawn_at_position(room, pos, cb):
        var bottomright = room.box.end * TOTAL_CELL_SIZE
        var rowtype = VerticalLongRow if _orientation == Orientation.VERTICAL else HorizontalLongRow
        var direction = Vector2(0, 1) if _orientation == Orientation.VERTICAL else Vector2(1, 0)

        var total_length
        if _orientation == Orientation.VERTICAL:
            total_length = bottomright.y - pos.y
        else:
            total_length = bottomright.x - pos.x

        var gap_size = 2

        var from_start = 0
        var index = 0

        var gaps = []
        for i in range(3):
            gaps.append(randi() % total_length)
        gaps.sort()

        while from_start < total_length:
            var current_gap = 99999
            if index < len(gaps):
                current_gap = gaps[index] - from_start
            var row = rowtype.new(_rate, _width, current_gap)
            var current_length = row.spawn_at_position(room, pos + from_start * direction, cb)
            from_start += current_length + gap_size

class LongRows extends FurniturePlacement:
    var _orientation: int

    func _init(orientation: int) -> void:
        _orientation = orientation

    func enumerate(_room) -> Array:
        return [0]

    func value_to_position(_value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    func spawn_at(room, _value, cb):
        var box = room.box
        var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)
        cells.position += Vector2(WALL_SIZE, WALL_SIZE)
        cells.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)

        var pos = cells.position
        var dir = Vector2(0, 1) if _orientation == Orientation.VERTICAL else Vector2(1, 0)

        pass # /////

class PlacementManager extends SpecialPlacementManager:

    func determine_placements(size: Vector2) -> Array:
        return []
