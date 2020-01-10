extends EdgeFurniturePlacement

const WardrobeScene = preload("Wardrobe.tscn")

func get_width() -> int:
    return 1

func spawn_at(position: Vector2, direction: int):
    var obj = WardrobeScene.instance()
    obj.position = position * 32
    obj.set_direction(direction)
    return obj
