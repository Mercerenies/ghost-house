extends Reference

const GeneratorGrid = preload("res://GeneratorGrid/GeneratorGrid.gd")
const Player = preload("res://Player/Player.gd")

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

var _data: Dictionary = {}
var _grid: GeneratorGrid = null
var _room: Room = null

func _init(room_data: Dictionary, grid: GeneratorGrid, room: Room):
    _data = room_data
    _grid = grid
    _room = room

static func is_blocked(room: Room, pos: Vector2) -> bool:
    return room.is_wall_at(pos) or room.get_entity_cell(pos) != null

static func can_put_furniture_at(room: Room, rect: Rect2) -> bool:
    # Check room bounds
    if not (room.is_in_bounds(rect.position) and room.is_in_bounds(rect.end)):
        return false
    # Check the position we want to put it at first
    for i in range(rect.size.x):
        for j in range(rect.size.y):
            if is_blocked(room, rect.position + Vector2(i, j)):
                return false
    var transitions = 0
    # Top edge
    for i in range(rect.size.x + 1):
        var pos = Vector2(rect.position.x - 1 + i, rect.position.y - 1)
        if is_blocked(room, pos) != is_blocked(room, pos + Vector2(1, 0)):
            transitions += 1
    # Right edge
    for i in range(rect.size.y + 1):
        var pos = Vector2(rect.end.x, rect.position.y - 1 + i)
        if is_blocked(room, pos) != is_blocked(room, pos + Vector2(0, 1)):
            transitions += 1
    # Bottom edge
    for i in range(rect.size.x + 1):
        var pos = Vector2(rect.end.x - i, rect.end.y)
        if is_blocked(room, pos) != is_blocked(room, pos + Vector2(-1, 0)):
            transitions += 1
    # Left edge
    for i in range(rect.size.y + 1):
        var pos = Vector2(rect.position.x - 1, rect.end.y - i)
        if is_blocked(room, pos) != is_blocked(room, pos + Vector2(0, -1)):
            transitions += 1
    return transitions <= 2

# TODO A few more of these could be made static as well

func is_doorway_at_position(pos: Vector2) -> bool:
    if not _room.is_wall_at(pos):
        # Left edge
        var cell = Vector2(floor(pos.x / TOTAL_CELL_SIZE), floor(pos.y / TOTAL_CELL_SIZE))
        if int(pos.x) % TOTAL_CELL_SIZE == 0:
            if _grid.get_value(cell) != _grid.get_value(cell + Vector2(-1, 0)):
                return true
        # Right edge
        if int(pos.x) % TOTAL_CELL_SIZE == TOTAL_CELL_SIZE - 1:
            if _grid.get_value(cell) != _grid.get_value(cell + Vector2(1, 0)):
                return true
        # Top Edge
        if int(pos.y) % TOTAL_CELL_SIZE == 0:
            if _grid.get_value(cell) != _grid.get_value(cell + Vector2(0, -1)):
                return true
        # Bottom Edge
        if int(pos.y) % TOTAL_CELL_SIZE == TOTAL_CELL_SIZE - 1:
            if _grid.get_value(cell) != _grid.get_value(cell + Vector2(0, 1)):
                return true
    return false

func is_blocking_doorway(rect: Rect2) -> bool:
    for i in range(rect.size.x + 2):
        for j in range(rect.size.y + 2):
            # Cut the corners
            if (i == 0 or i == rect.size.x + 1) and (j == 0 or j == rect.size.y + 1):
                continue
            # Perform the check
            if is_doorway_at_position(rect.position + Vector2(i - 1, j - 1)):
                return true
    return false

func consider_turning_evil(obj) -> void:
    var chance = _data['config']['percent_evil'] * obj.chance_of_turning_evil()
    if randf() < chance:
        obj.turn_evil()

func add_entity(pos: Vector2, entity: Object) -> void:
    _room.get_node("Entities").add_child(entity)
    entity.position = pos * 32
    entity.position_self()
    if entity is Player:
        _room.get_marked_entities()["player"] = entity
