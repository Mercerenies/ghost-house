extends Node

func _ready():
    pass

# Half-open interval
func randi_range(mn: int, mx: int) -> int:
    return randi() % (mx - mn) + mn