extends Reference
class_name FurniturePlacement

func enumerate(_room) -> Array:
    # Returns an array of values indicating possible placements. These values can really be anything,
    # as they'll just be passed to value_to_position later.
    return []

func value_to_position(_value) -> Rect2:
    return GeneratorData.PLACEMENT_INVALID

func spawn_at(_room, _value, _cb):
    pass

func can_block_doorways() -> bool:
    return false
