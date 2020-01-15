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

class ChaoticTables extends FurniturePlacement:

    func enumerate(_room) -> Array:
        return [0]

    func value_to_position(_value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    func spawn_at(room, value, cb):
        # ///// Refine me then make some variants
        var box = room.box
        var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)
        cells.position += Vector2(WALL_SIZE, WALL_SIZE)
        cells.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)

        for _i in range(10):
            var curr
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
            var pos = Vector2(Util.randi_range(cells.position.x, cells.end.x),
                              Util.randi_range(cells.position.y, cells.end.y))
            curr = curr.spawn_at(room, { "position": pos }, cb)
            if not (curr is Array):
                curr = [curr]
            for v in curr:
                cb.call(v)

class PlacementManager extends SpecialPlacementManager:

    func _chaotic_tables(min_count: int, max_count: int) -> Array:
        # "Chaotic Tables" Layout
        var count = Util.randi_range(min_count, max_count + 1)
        var arr = []
        for _i in range(count):
            var curr
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
            arr.append(curr)
        return arr

    func determine_placements(size: Vector2) -> Array:
        var min_dim = min(size.x, size.y)
        var max_dim = max(size.x, size.y)

        return [ChaoticTables.new()] # _chaotic_tables(2 * max_dim, 2 * max_dim + 2)
