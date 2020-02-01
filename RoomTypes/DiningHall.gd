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
        var success = false
        while length >= 3:
            table = DiningTable.instance()
            table.set_dims(Vector2(_width, length))
            table.position = 32 * pos
            if cb.call(table):
                # Success
                success = true
                break
            length -= 1
        if not success:
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

        var total_length: int
        if _orientation == Orientation.VERTICAL:
            total_length = bottomright.y - pos.y
        else:
            total_length = bottomright.x - pos.x

        var gap_size = 2

        var from_start = 0
        var index = 0

        var gaps = []
        for _i in range(3):
            gaps.append(randi() % total_length)
        gaps.sort()

        while from_start < total_length:
            var current_gap = 99999
            while index < len(gaps) and gaps[index] < from_start:
                index += 1
            if index < len(gaps):
                current_gap = gaps[index] - from_start
            var row = rowtype.new(_rate, _width, current_gap)
            var current_length = row.spawn_at_position(room, pos + from_start * direction, cb)
            if current_length >= 0:
                from_start += current_length + gap_size
            else:
                from_start += gap_size

class LongRows extends FurniturePlacement:
    var _rate: float
    var _orientation: int

    func _init(rate: float, orientation: int) -> void:
        _rate = rate
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
        var dir = Vector2(1, 0) if _orientation == Orientation.VERTICAL else Vector2(0, 1)

        var jump_speed = 6
        if randf() < 0.1:
            jump_speed = 7

        pos += dir
        if randf() < 0.25:
            pos += dir

        var longrow = LongRowWithBreaks.new(_rate, 2, _orientation)

        while pos.x < cells.end.x and pos.y < cells.end.y:
            longrow.spawn_at_position(room, pos, cb)
            pos += jump_speed * dir

class PlacementManager extends SpecialPlacementManager:

    func determine_placements(size: Vector2) -> Array:
        var orientation
        if size.x == size.y:
            # Dims are equal so pick randomly
            orientation = Orientation.VERTICAL if randf() < 0.5 else Orientation.HORIZONTAL
        elif size.x > size.y:
            # Longways horizontal
            orientation = Orientation.VERTICAL if randf() < 0.2 else Orientation.HORIZONTAL
        else:
            # Longways vertical
            orientation = Orientation.VERTICAL if randf() < 0.8 else Orientation.HORIZONTAL
        var rate = Util.choose([0.0, 0.5, 0.5, 0.5, 0.75, 1.0, 1.0])
        return [LongRows.new(rate, orientation)]
