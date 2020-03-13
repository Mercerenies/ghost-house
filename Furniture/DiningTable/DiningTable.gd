extends Furniture

func _ready() -> void:
    interaction["idle"] = [
        { "command": "say", "text": "A dining room table." }
    ]

func set_dims(v: Vector2) -> void:
    # Dims of this object can be set freely, subject to the constraint
    # that the smallest valid size is 2x2.
    v = Vector2(max(v.x, 2), max(v.y, 2))
    .set_dims(v)
    update()

func chance_of_turning_evil() -> float:
    # It looks weird if a table too large goes vanishing, and it
    # messes with the idea of "looking" at furniture (as the point
    # used for reference is the top left corner) and you get into
    # situations where you can be standing next to it and it's still
    # disappeared entirely. Bottom line: sufficiently large furniture
    # shouldn't vanish.
    var dims = get_dims()
    var max_dim = max(dims.x, dims.y)
    return 1.0 if max_dim < 5 else 0.0

func _draw() -> void:
    var dims = get_dims()
    var tex = $Sprite.get_texture()
    for i in range(dims.x):
        for j in range(dims.y):
            var sprite_img = Vector2(1, 1)
            if i == 0:
                sprite_img.x -= 1
            elif i == dims.x - 1:
                sprite_img.x += 1
            if j == 0:
                sprite_img.y -= 1
            elif j == dims.y - 1:
                sprite_img.y += 1
            sprite_img *= 32
            var src_rect  = Rect2(sprite_img, Vector2(32, 32))
            var dest_rect = Rect2(Vector2(i * 32, j * 32), Vector2(32, 32))
            draw_texture_rect_region(tex, dest_rect, src_rect)
