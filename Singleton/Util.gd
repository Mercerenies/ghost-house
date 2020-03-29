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

func map_values(obj, funcname, d0) -> Dictionary:
    var d = {}
    for k in d0:
        d[k] = obj.call(funcname, d0[k])
    return d

func filter(obj, funcname, xs) -> Array:
    var arr = []
    for x in xs:
        if obj.call(funcname, x):
            arr.append(x)
    return arr

# Deep-copies any JSON-serializable data (that is, arrays and dicts)
# arbitrarily nested. Does not check for cycles.
func deep_copy(obj):
    if obj is Array:
        return map(self, "deep_copy", obj)
    if obj is Array:
        return map_values(self, "deep_copy", obj)
    return obj

# Each entry should be { "result": result, "weight": weight }, where
# the weights are nonnegative integers.
func weighted_choose(values: Array):
    var total = 0
    for v in values:
        total += v["weight"]
    var choice = randi() % int(total)
    for v in values:
        choice -= v["weight"]
        if choice < 0:
            return v["result"]
    return null # This shouldn't happen

# NOTE: Right now, I'm using an asymptotically inferior O(n^2)
# algorithm to do this. I could easily rewrite it to O(nlogn), but to
# be quite frank, I'm mainly calling this on small arrays, so I don't
# think asymptotics really matter here, and this way may actually be
# more efficient for small data than sorting first.
func intersection(arr1: Array, arr2: Array) -> Array:
    var result = []
    for a in arr1:
        for b in arr2:
            if a == b:
                result.append(a)
    return result

# Removes duplicate elements (as determined by ==) from a SORTED list.
# The argument to this function should already have been sorted, so
# that identical elements are adjacent. A new list is returned.
func dedup_sorted(arr: Array) -> Array:
    var res = []
    if len(arr) == 0:
        return res
    res.append(arr[0])
    for k in range(1, len(arr)):
        if arr[k] != arr[k - 1]:
            res.append(arr[k])
    return res
