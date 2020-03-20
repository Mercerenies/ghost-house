extends Reference

##################################
# STAGE 2 - LIVE ROOM GENERATION #
##################################

const RoomData = GeneratorData.RoomData

const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const GeneratorPainter = preload("res://Generator/GeneratorPainter/GeneratorPainter.gd")

const ID_OOB = GeneratorData.ID_OOB
const ID_DEAD = GeneratorData.ID_DEAD
const ID_EMPTY = GeneratorData.ID_EMPTY
const ID_HALLS = GeneratorData.ID_HALLS
const ID_ROOMS = GeneratorData.ID_ROOMS

var _data: Dictionary = {}
var _grid: GeneratorGrid = null
var _painter: GeneratorPainter = null

func _init(room_data: Dictionary, grid: GeneratorGrid, painter: GeneratorPainter):
    _data = room_data
    _grid = grid
    _painter = painter

func _can_draw_hypothetical_box(box: Rect2, hypo_box: Rect2) -> bool:
    if box.intersects(hypo_box):
        return false
    for i in range(box.size.x):
        for j in range(box.size.y):
            var pos = _grid.get_value(Vector2(box.position.x + i, box.position.y + j))
            if pos == ID_OOB or pos >= ID_HALLS:
                return false
    return true

func _can_draw_box(box: Rect2) -> bool:
    return _can_draw_hypothetical_box(box, Rect2(Vector2(), Vector2()))

func _is_cell_hypothetically_dead(pos: Vector2, new_box: Rect2) -> bool:
    if _can_draw_hypothetical_box(Rect2(pos, Vector2(2, 2)), new_box):
        return false
    if _can_draw_hypothetical_box(Rect2(pos + Vector2(-1, 0), Vector2(2, 2)), new_box):
        return false
    if _can_draw_hypothetical_box(Rect2(pos + Vector2(0, -1), Vector2(2, 2)), new_box):
        return false
    if _can_draw_hypothetical_box(Rect2(pos + Vector2(-1, -1), Vector2(2, 2)), new_box):
        return false
    return true

func _is_cell_dead(pos: Vector2) -> bool:
    return _is_cell_hypothetically_dead(pos, Rect2(Vector2(), Vector2()))

func _mark_dead_cells() -> void:
    var w = _grid.get_width()
    var h = _grid.get_height()
    for i in range(w):
        for j in range(h):
            if _grid.get_value(Vector2(i, j)) == ID_EMPTY and _is_cell_dead(Vector2(i, j)):
                _grid.set_value(Vector2(i, j), ID_DEAD)

func _enumerate_rectangles(pos: Vector2) -> Dictionary:
    # This is an absolute BS O(n^4) (at least in principle) algorithm right now.
    # Please please please for the love of all that is good, make this more efficient.
    var dead = []
    var alive = []
    for width in [2, 3, 4]:
        for height in [2, 3, 4]:
            for left_offset in range(1 - width, 1):
                for top_offset in range(1 - height, 1):
                    var rect = Rect2(pos + Vector2(left_offset, top_offset), Vector2(width, height))
                    if _can_draw_box(rect):
                        if _creates_dead_cells(rect):
                            dead.append(rect)
                        else:
                            alive.append(rect)
    return {
        'dead': dead,
        'alive': alive
    }

func _creates_dead_cells(box: Rect2) -> bool:
    var pos
    # Top and bottom edges
    for i in range(-1, box.size.x + 1):
        pos = box.position + Vector2(i, -1)
        if _grid.get_value(pos) == ID_EMPTY and _is_cell_hypothetically_dead(pos, box):
            return true
        pos = box.end - Vector2(i + 1, 0)
        if _grid.get_value(pos) == ID_EMPTY and _is_cell_hypothetically_dead(pos, box):
            return true
    # Left and right edges
    for i in range(-1, box.size.y + 1):
        pos = box.position + Vector2(-1, i)
        if _grid.get_value(pos) == ID_EMPTY and _is_cell_hypothetically_dead(pos, box):
            return true
        pos = box.end - Vector2(0, i + 1)
        if _grid.get_value(pos) == ID_EMPTY and _is_cell_hypothetically_dead(pos, box):
            return true
    return false

func _produce_live_rooms(start_id: int) -> int:
    _mark_dead_cells()

    var current_id = start_id
    var w = _grid.get_width()
    var h = _grid.get_height()
    var cells = []
    for i in range(w):
        for j in range(h):
            if _grid.get_value(Vector2(i, j)) == ID_EMPTY:
                cells.append(Vector2(i, j))
    cells.shuffle()

    for pos in cells:
        if _grid.get_value(pos) != ID_EMPTY:
            continue
        var rects = _enumerate_rectangles(pos)
        var dead = rects['dead']
        var alive = rects['alive']
        var rect
        #print("Cell: {0}\nDead: {1}\nAlive: {2}".format([pos, str(dead), str(alive)]))
        if not alive.empty():
            rect = alive[randi() % len(alive)]
        else:
            #print("DEAD")
            rect = dead[randi() % len(dead)]
        _painter.paint(RoomData.new(current_id, rect))
        current_id += 1
        _mark_dead_cells()

    return current_id

func run(start_id: int) -> int:
    return _produce_live_rooms(start_id)
