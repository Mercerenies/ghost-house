extends Node

func _ready():
    pass

# Half-open interval
func randi_range(mn: int, mx: int) -> int:
    return randi() % (mx - mn) + mn

func toward(value: float, delta: float, target: float) -> float:
    if abs(target - value) <= delta:
        return target
    return value + sign(target - value) * delta

func choose(arr: Array):
    return arr[randi() % len(arr)]

func random_dir() -> Vector2:
    match randi() % 4:
        0:
            return Vector2(1, 0)
        1:
            return Vector2(-1, 0)
        2:
            return Vector2(0, 1)
        3:
            return Vector2(0, -1)
    return Vector2(1, 0) # Idk

func transpose_v(vec: Vector2) -> Vector2:
    return Vector2(vec.y, vec.x)

func transpose_r(rect: Rect2) -> Rect2:
    return Rect2(transpose_v(rect.position), transpose_v(rect.size))

# https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle
func point_in_polygon(point: Vector2, poly: Array) -> bool:
    var pos = false
    var neg = false
    for i in range(len(poly)):
        var p1 = poly[i]
        var p2 = poly[(i + 1) % len(poly)]
        var det = (point.x - p2.x) * (p1.y - p2.y) - (p1.x - p2.x) * (point.y - p2.y)
        if det < 0:
            neg = true
        else:
            pos = true
        if neg and pos:
            return false
    return true

func map(obj, funcname, xs) -> Array:
    var arr = []
    for x in xs:
        arr.append(obj.call(funcname, x))
    return arr
