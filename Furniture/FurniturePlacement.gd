extends Reference
class_name FurniturePlacement

func enumerate(room) -> Array:
    # Returns an array of values indicating possible placements. These values can really be anything,
    # as they'll just be passed to value_to_position later.
    return []

func value_to_position(value) -> Rect2:
    return Rect2(-99, -99, 1, 1) # Please override me. This behavior is not desired.

func spawn_at(value):
    pass

func can_block_doorways() -> bool:
    return false