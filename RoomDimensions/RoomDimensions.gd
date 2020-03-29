extends Node
class_name RoomDimensions

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

const Connection = preload("res://Generator/Connection/Connection.gd")

# Takes a connection from the ConnectionGenerator or the minimap and
# returns the 2x2 rectangle bounding it.
static func connection_rect(connection: Connection) -> Rect2:
    var pos0 = connection.get_pos0()
    var pos1 = connection.get_pos1()
    var diff = pos1 - pos0

    # This should be enforced by the ConnectionGenerator upon
    # generating the room and also by Connection in the constructor.
    assert(diff in [Vector2(1, 0), Vector2(0, 1)])

    var room_upperleft = pos1 * TOTAL_CELL_SIZE
    var tr_upperleft = room_upperleft + Vector2(-1, -1) + Vector2(diff.y, diff.x) * TOTAL_CELL_SIZE / 2
    return Rect2(tr_upperleft, Vector2(2, 2))

# Takes a position in the grid and returns the generator cell to which it belongs
static func cell_to_generator_cell(pos: Vector2) -> Vector2:
    return Vector2(floor(pos.x / TOTAL_CELL_SIZE), floor(pos.y / TOTAL_CELL_SIZE))
