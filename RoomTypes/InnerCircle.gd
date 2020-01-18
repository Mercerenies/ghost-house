extends FurniturePlacement

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

# Direction mask specifies which sides to put seats on. Bit 0
# is right side, bit 1 is bottom, etc.

func direction_masks() -> Array:
    # Abstract; override me
    return []

func determine_params():
    # Abstract, override me
    return null

func determine_exterior_padding() -> int:
    # Abstract, override me
    return 0

func generate_furniture(max_len, params):
    # Abstract; override me
    pass

func enumerate(room) -> Array:
    var direction_masks = direction_masks()
    var arr = []
    for mask in direction_masks:
        arr.append({ "direction_mask": mask })
    return arr

func value_to_position(_value) -> Rect2:
    return GeneratorData.PLACEMENT_SAFE

func spawn_at(room, value, cb):

    var box = room.box
    var i
    var dir_mask = value['direction_mask']
    var params = determine_params()

    var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)

    var exterior_padding = determine_exterior_padding()
    exterior_padding = min(exterior_padding, min(cells.size.x / 2 - 4, cells.size.y / 2 - 4))

    cells.position += Vector2(WALL_SIZE + exterior_padding, WALL_SIZE + exterior_padding)
    cells.size -= 2 * Vector2(WALL_SIZE + exterior_padding, WALL_SIZE + exterior_padding)

    if exterior_padding == 1 and dir_mask == 15:
        # This combination of parameters pretty much eliminates all edge furniture
        # and leaves an awkward one-cell boundary around the whole edge, so forbid it
        exterior_padding = 0

    var arr = []
    var pos = cells.position
    var lengthx = cells.size.x
    var lengthy = cells.size.y

    # Top
    if dir_mask & 8:
        i = 1
        while i < lengthx - 1:
            var max_len = max(lengthx - 1 - i, 1)
            var furniture = generate_furniture(max_len, params)
            furniture["object"].set_direction(1)
            furniture["object"].position = 32 * (pos + Vector2(i, 0))
            arr.append(furniture["object"])
            i += furniture["length"]

    # Bottom
    if dir_mask & 2:
        i = 1
        while i < lengthx - 1:
            var max_len = max(lengthx - 1 - i, 1)
            var furniture = generate_furniture(max_len, params)
            furniture["object"].set_direction(3)
            furniture["object"].position = 32 * (pos + Vector2(i, lengthy - 1))
            arr.append(furniture["object"])
            i += furniture["length"]

    # Left
    if dir_mask & 4:
        i = 1
        while i < lengthy - 1:
            var max_len = max(lengthy - 1 - i, 1)
            var furniture = generate_furniture(max_len, params)
            furniture["object"].set_direction(0)
            furniture["object"].position = 32 * (pos + Vector2(0, i))
            arr.append(furniture["object"])
            i += furniture["length"]

    # Right
    if dir_mask & 1:
        i = 1
        while i < lengthy - 1:
            var max_len = max(lengthy - 1 - i, 1)
            var furniture = generate_furniture(max_len, params)
            furniture["object"].set_direction(2)
            furniture["object"].position = 32 * (pos + Vector2(lengthx - 1, i))
            arr.append(furniture["object"])
            i += furniture["length"]

    arr.shuffle()
    for obj in arr:
        cb.call(obj)
