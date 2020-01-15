extends Node

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

const CircularDiningTablePlacement = preload("res://Furniture/CircularDiningTable/CircularDiningTablePlacement.gd")
const DiningTablePlacement = preload("res://Furniture/DiningTable/DiningTablePlacement.gd")
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

class SurroundedInChairs extends FurniturePlacement:
    var _inner: FurniturePlacement
    var _rate: float

    func _init(inner: FurniturePlacement, rate: float) -> void:
        # Note: The inner placement object should always directly
        # specify its bounds. Use of PLACEMENT_SAFE is not permitted
        # here and will result in a SurroundedInChairs instance which
        # never spawns.
        _inner = inner
        _rate = rate

    func enumerate(room) -> Array:
        return _inner.enumerate(room)

    func value_to_position(value) -> Rect2:
        var result = _inner.value_to_position(value)
        if result == GeneratorData.PLACEMENT_SAFE: # Not supported
            return GeneratorData.PLACEMENT_INVALID
        if GeneratorData.is_placement_constant(result):
            return result # Pass through
        return Rect2(result.position - Vector2(1, 1), result.size + Vector2(2, 2))

    func spawn_at(room, value, cb):
        var _cb_helper = _SurroundedInChairsCallback.new(cb)
        _inner.spawn_at(room, value, _cb_helper)
        if _cb_helper.has_failed():
            # Couldn't place the interior so don't try the chairs
            return

        var bounds = _inner.value_to_position(value)
        var upperleft = bounds.position - Vector2(1, 1)

        # Top and Bottom
        for i in range(bounds.size.x):
            if randf() < _rate:
                cb.call(_Helper._make_chair_facing(upperleft + Vector2(i + 1, 0), 1))
            if randf() < _rate:
                cb.call(_Helper._make_chair_facing(upperleft + Vector2(i + 1, bounds.size.y + 1), 3))

        # Left and Right
        for i in range(bounds.size.y):
            if randf() < _rate:
                cb.call(_Helper._make_chair_facing(upperleft + Vector2(0, i + 1), 0))
            if randf() < _rate:
                cb.call(_Helper._make_chair_facing(upperleft + Vector2(bounds.size.x + 1, i + 1), 2))

class ScatteredTablePlacement extends FurniturePlacement:

    func enumerate(_room) -> Array:
        return [0]

    func value_to_position(_value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    func placement_object() -> FurniturePlacement:
        return null

    func count(bounds: Vector2) -> int:
        var max_dim = max(bounds.x, bounds.y)
        return Util.randi_range(max_dim, max_dim + 2)

    func spawn_at(room, _value, cb):
        var box = room.box
        var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)
        cells.position += Vector2(WALL_SIZE, WALL_SIZE)
        cells.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)

        var count = count(box.size)

        for _i in range(count):
            var curr = placement_object()
            if curr == null:
                continue
            var pos = Vector2(Util.randi_range(cells.position.x, cells.end.x),
                              Util.randi_range(cells.position.y, cells.end.y))
            curr.spawn_at(room, { "position": pos }, cb)

class ChaoticTables extends ScatteredTablePlacement:

    func placement_object() -> FurniturePlacement:
        var curr = null
        match randi() % 9:
            0, 1:
                curr = CircularDiningTablePlacement.new()
            2, 3:
                curr = DiningTablePlacement.new(Vector2(2, 2))
            4, 5:
                curr = DiningTablePlacement.new(Vector2(3, 2))
            6, 7:
                curr = DiningTablePlacement.new(Vector2(2, 3))
            8:
                curr = DiningTablePlacement.new(Vector2(3, 3))
        if randf() < 0.9:
            var rate = Util.choose([0.7, 0.8, 0.9, 1.0])
            curr = SurroundedInChairs.new(curr, rate)
        return curr

class UniformTables extends ScatteredTablePlacement:
    var _type

    func _init(type=null):
        if type == null:
            type = Util.choose([CircularDiningTablePlacement.new(),
                                DiningTablePlacement.new(Vector2(2, 2))])
        _type = type

    func placement_object() -> FurniturePlacement:
        var curr = _type
        if randf() < 0.9:
            var rate = Util.choose([0.7, 0.8, 0.9, 1.0])
            curr = SurroundedInChairs.new(curr, rate)
        return curr

class UniformTablesWithChairs extends ScatteredTablePlacement:
    var _type

    func _init(type=null):
        if type == null:
            type = Util.choose([CircularDiningTablePlacement.new(),
                                DiningTablePlacement.new(Vector2(2, 2))])
        type = SurroundedInChairs.new(type, 1.0)
        _type = type

    func placement_object() -> FurniturePlacement:
        return _type

class UniformTablesWithoutChairs extends ScatteredTablePlacement:
    var _type

    func _init(type=null):
        if type == null:
            type = Util.choose([CircularDiningTablePlacement.new(),
                                DiningTablePlacement.new(Vector2(2, 2)),
                                DiningTablePlacement.new(Vector2(2, 3)),
                                DiningTablePlacement.new(Vector2(3, 2))])
        _type = type

    func count(bounds: Vector2) -> int:
        return .count(bounds) + 2

    func placement_object() -> FurniturePlacement:
        return _type

class TableGrid extends FurniturePlacement:
    var _type

    func _init(type=null):
        if type == null:
            type = Util.choose([CircularDiningTablePlacement.new(),
                                DiningTablePlacement.new(Vector2(2, 2))])
        _type = type

    func enumerate(_room) -> Array:
        return [0]

    func value_to_position(_value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    func spawn_at(room, _value, cb):
        var placement = SurroundedInChairs.new(_type, 1.0)

        var box = room.box
        var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)
        cells.position += Vector2(WALL_SIZE, WALL_SIZE)
        cells.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)

        var start = cells.position
        start += Vector2(randi() % 3, randi() % 3)

        for i in range(start.x, cells.end.x, 6):
            for j in range(start.y, cells.end.y, 6):
                placement.spawn_at(room, { "position": Vector2(i, j) }, cb)

class PlacementManager extends SpecialPlacementManager:

    func determine_placements(size: Vector2) -> Array:
        var min_dim = min(size.x, size.y)
        var max_dim = max(size.x, size.y)

        if max_dim >= 3 and randf() < 0.1:
            return [TableGrid.new()]
        if min_dim >= 3 and randf() < 0.3:
            return [TableGrid.new()]

        var chair_type
        match randi() % 13:
            0, 1, 2:
                chair_type = CircularDiningTablePlacement.new()
            3, 4, 5:
                chair_type = DiningTablePlacement.new(Vector2(2, 2))
            6, 7:
                chair_type = DiningTablePlacement.new(Vector2(2, 3))
            8, 9:
                chair_type = DiningTablePlacement.new(Vector2(3, 2))
            10:
                chair_type = DiningTablePlacement.new(Vector2(3, 3))
            11:
                chair_type = DiningTablePlacement.new(Vector2(4, 2))
            12:
                chair_type = DiningTablePlacement.new(Vector2(2, 4))

        match randi() % 4:
            0:
                return [ChaoticTables.new()]
            1:
                return [UniformTables.new(chair_type)]
            2:
                return [UniformTablesWithChairs.new(chair_type)]
            3:
                return [UniformTablesWithoutChairs.new(chair_type)]
