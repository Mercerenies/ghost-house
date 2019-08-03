extends EdgeFurniturePlacement

const BookshelfScene = preload("Bookshelf.tscn")

func get_width() -> int:
    return 1

func spawn_at(position: Vector2, direction: int):
    var obj = BookshelfScene.instance()
    obj.position = position * 32
    obj.set_direction(direction)
    return obj
