extends EdgeFurniturePlacement

# This doesn't really actually override any of the EdgeFurniturePlacement behavior,
# but we're treating that class as pseudo-abstract, so this is a minimal concrete
# implementation which does nothing.

func get_width() -> int:
    return 1

func spawn_at(position: Vector2, direction: int):
    pass
