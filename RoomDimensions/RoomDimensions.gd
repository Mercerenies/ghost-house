extends Node
class_name RoomDimensions

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

# Takes a connection from the ConnectionGenerator or the minimap and
# returns the 2x2 rectangle bounding it.
static func connection_rect(connection: Dictionary) -> Rect2:
    var pos0 = connection['pos'][0]
    var pos1 = connection['pos'][1]
    var diff = pos1 - pos0

    # This should be enforced by the ConnectionGenerator upon
    # generating the room.
    assert(diff in [Vector2(1, 0), Vector2(0, 1)])

    var room_upperleft = pos1 * TOTAL_CELL_SIZE
    var tr_upperleft = room_upperleft + Vector2(-1, -1) + Vector2(diff.y, diff.x) * TOTAL_CELL_SIZE / 2
    return Rect2(tr_upperleft, Vector2(2, 2))
