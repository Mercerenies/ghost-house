extends FurniturePlacement

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

enum Orientation {
    HORIZONTAL, VERTICAL
}

func generate_furniture(value):
    # Abstract method; override me
    pass

func get_orientation():
    # Abstract method; override me
    pass

func get_gap_size():
    # Abstract method; override me
    pass

func value_to_position(value) -> Rect2:
    return GeneratorData.PLACEMENT_SAFE

func spawn_at(room, value):
    var box = room.box

    var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)
    cells.position += Vector2(WALL_SIZE, WALL_SIZE)
    cells.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)

    var orientation = get_orientation()
    var gap_size = get_gap_size()

    if orientation == Orientation.VERTICAL:
        # Transpose the bounds; we'll do all the calculations as
        # though we're doing horizontal rows (to keep things
        # consistent and avoid duplicating all this code) and then
        # transform the furniture positions at the end.
        cells = Util.transpose_r(cells)

    var arr = []

    var pos = cells.position
    var xvel = 1
    var yvel = gap_size

    if randf() < 0.5:
        # Flip
        pos.x = cells.end.x - 1
        xvel *= -1

    pos += Vector2(sign(xvel) * (randi() % 2), randi() % 3)

    while pos.y < cells.end.y:
        var choice = generate_furniture(value)
        var obj = choice['object']
        var transformed_pos = pos
        if orientation == Orientation.VERTICAL:
            transformed_pos = Util.transpose_v(transformed_pos)
        arr.append({ "object": obj, "position": transformed_pos })
        pos.x += choice['length'] * xvel
        if xvel > 0:
            if pos.x >= cells.end.x:
                pos.y += yvel
                xvel *= -1
        else:
            if pos.x < cells.position.x:
                pos.y += yvel
                xvel *= -1

    arr.shuffle()
    return arr
