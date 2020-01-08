extends Node

const Sofa = preload("res://Furniture/Sofa/Sofa.tscn")
const Recliner = preload("res://Furniture/Recliner/Recliner.tscn")

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

class _Helper:

    static func _make_furniture(max_len):
        if max_len >= 2 and randf() < 0.9:
            return { "object": Sofa.instance(), "length": 2 }
        return { "object": Recliner.instance(), "length": 1 }

class CornerSeat extends FurniturePlacement:

    func enumerate(room) -> Array:
        if not (room is GeneratorData.RoomData):
            return []

        var rect = Rect2(room.box.position * TOTAL_CELL_SIZE, room.box.size * TOTAL_CELL_SIZE)
        var arr = []
        for i in range(rect.size.x):
            for j in range(rect.size.y):
                arr.append({
                    "position": rect.position + Vector2(i, j),
                    "length": 4,
                })
        return arr

    func value_to_position(value) -> Rect2:
        var pos = value["position"]
        var size = Vector2(value["length"], value["length"])
        return Rect2(pos, size)

    func spawn_at(value):

        # Direction is the direction of the first set of sofas, second
        # set is clockwise (positive angle) from there.
        var dir1 = randi() % 4
        var dir2 = (dir1 + 1) % 4
        var length = value["length"]
        var pos = value["position"]
        var i

        var arr = []

        # Top
        if dir1 == 3 or dir2 == 3:
            i = 1
            while i < length - 1:
                var max_len = max(length - 1 - i, 1)
                var furniture = _Helper._make_furniture(max_len)
                furniture["object"].set_direction(1)
                arr.append({ "object": furniture["object"], "position": pos + Vector2(i, 0) })
                i += furniture["length"]

        # Bottom
        if dir1 == 1 or dir2 == 1:
            i = 1
            while i < length - 1:
                var max_len = max(length - 1 - i, 1)
                var furniture = _Helper._make_furniture(max_len)
                furniture["object"].set_direction(3)
                arr.append({ "object": furniture["object"], "position": pos + Vector2(i, length - 1) })
                i += furniture["length"]

        # Left
        if dir1 == 2 or dir2 == 2:
            i = 1
            while i < length - 1:
                var max_len = max(length - 1 - i, 1)
                var furniture = _Helper._make_furniture(max_len)
                furniture["object"].set_direction(0)
                arr.append({ "object": furniture["object"], "position": pos + Vector2(0, i) })
                i += furniture["length"]

        # Right
        if dir1 == 0 or dir2 == 0:
            i = 1
            while i < length - 1:
                var max_len = max(length - 1 - i, 1)
                var furniture = _Helper._make_furniture(max_len)
                furniture["object"].set_direction(2)
                arr.append({ "object": furniture["object"], "position": pos + Vector2(length - 1, i) })
                i += furniture["length"]

        return arr
