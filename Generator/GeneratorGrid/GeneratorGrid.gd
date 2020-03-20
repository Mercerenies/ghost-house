extends Reference

var _grid: Array = [] # Row major (y + x * h)
var _width: int = 0
var _height: int = 0
var _oob = null

func _init(width: int, height: int, init, oob = null):
    _grid = []
    for _i in range(width * height):
        _grid.append(init)
    _width = width
    _height = height
    _oob = oob

func get_value(pos: Vector2):
    if pos.x < 0 or pos.y < 0 or pos.x >= _width or pos.y >= _height:
        return _oob
    return _grid[pos.y + pos.x * _height]

func set_value(pos: Vector2, value) -> void:
    if pos.x < 0 or pos.y < 0 or pos.x >= _width or pos.y >= _height:
        return
    _grid[pos.y + pos.x * _height] = value

func get_flag(pos: Vector2, bit: int) -> bool:
    if pos.x < 0 or pos.y < 0 or pos.x >= _width or pos.y >= _height:
        return false
    return _grid[pos.y + pos.x * _height] & (1 << bit)

func set_flag(pos: Vector2, bit: int, value: bool) -> void:
    if pos.x < 0 or pos.y < 0 or pos.x >= _width or pos.y >= _height:
        return
    if value:
        _grid[pos.y + pos.x * _height] |= (1 << bit)
    else:
        _grid[pos.y + pos.x * _height] &= ~(1 << bit)

func get_width() -> int:
    return _width

func get_height() -> int:
    return _height
