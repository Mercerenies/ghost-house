extends Node

const Image = preload("FurnitureShim.png")

func index_to_rect(index: int) -> Rect2:
    # warning-ignore: integer_division
    var width = Image.get_width() / 32
    return Rect2(Vector2(32 * (index % width), 32 * floor(index / width)), Vector2(32, 32))
