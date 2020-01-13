extends Node

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

const CircularDiningTablePlacement = preload("res://Furniture/CircularDiningTable/CircularDiningTablePlacement.gd")
const DiningChair = preload("res://Furniture/DiningChair/DiningChair.tscn")

class _Helper:

    static func _make_chair_facing(pos: Vector2, dir: int):
        var chair = DiningChair.instance()
        chair.position = pos * 32
        chair.set_direction(dir)
        return { "object": chair, "position": pos }

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

    func spawn_at(room, value):
        var arr = _inner.spawn_at(room, value)
        if not (arr is Array):
            arr = [arr]

        var bounds = _inner.value_to_position(value)
        var upperleft = bounds.position - Vector2(1, 1)

        # Top and Bottom
        for i in range(bounds.size.x):
            if randf() < _rate:
                arr.append(_Helper._make_chair_facing(upperleft + Vector2(i + 1, 0), 1))
            if randf() < _rate:
                arr.append(_Helper._make_chair_facing(upperleft + Vector2(i + 1, bounds.size.y + 1), 3))

        # Left and Right
        for i in range(bounds.size.y):
            if randf() < _rate:
                arr.append(_Helper._make_chair_facing(upperleft + Vector2(0, i + 1), 0))
            if randf() < _rate:
                arr.append(_Helper._make_chair_facing(upperleft + Vector2(bounds.size.x + 1, i + 1), 2))

        return arr
