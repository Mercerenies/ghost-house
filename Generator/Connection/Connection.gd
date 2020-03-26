extends Reference

enum LockType {
    NONE = 0,
    SIMPLE_LOCK = 1,
}

var _pos0: Vector2
var _pos1: Vector2
var _lock: int

# For use with the Graph class as an incidence function.
class Incidence:
    var _grid

    # Takes a GeneratorGrid
    func _init(grid) -> void:
        _grid = grid

    func incidence(edge) -> Array:
        return [_grid.get_value(edge.get_pos0()), _grid.get_value(edge.get_pos1())]

func _init(pos: Array) -> void:
    assert(len(pos) == 2)

    self._pos0 = pos[0]
    self._pos1 = pos[1]
    self._lock = LockType.NONE

    var diff = _pos1 - _pos0
    if diff in [Vector2(-1, 0), Vector2(0, -1)]:
        var tmp = _pos1
        _pos1 = _pos0
        _pos0 = tmp
        diff = _pos1 - _pos0
    assert(diff in [Vector2(1, 0), Vector2(0, 1)])

func get_pos0() -> Vector2:
    return _pos0

func get_pos1() -> Vector2:
    return _pos1

func get_lock() -> int:
    return self._lock

func set_lock(lock_type: int) -> void:
    self._lock = lock_type
