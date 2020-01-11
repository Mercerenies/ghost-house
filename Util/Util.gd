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
