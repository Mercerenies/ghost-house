extends Node

const Sofa = preload("res://Furniture/Sofa/Sofa.tscn")
const Recliner = preload("res://Furniture/Recliner/Recliner.tscn")
const DeskLamp = preload("res://Furniture/DeskLamp/DeskLamp.tscn")
const FloorLamp = preload("res://Furniture/FloorLamp/FloorLamp.tscn")

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

enum Strictness {
    MANY_OTHERS = 0,
    FEW_OTHERS = 1,
    ONLY_CHAIRS = 2,
}

class _Helper:

    static func _make_variety_furniture():
        match randi() % 2:
            0:
                return { "object": DeskLamp.instance(), "length": 1 }
            1:
                return { "object": FloorLamp.instance(), "length": 1 }

    static func _make_furniture(max_len, strictness):
        if strictness <= Strictness.MANY_OTHERS and randf() < 0.15:
            return _make_variety_furniture()
        if strictness <= Strictness.FEW_OTHERS and randf() < 0.1:
            return _make_variety_furniture()
        if max_len >= 2 and randf() < 0.9:
            return { "object": Sofa.instance(), "length": 2 }
        return { "object": Recliner.instance(), "length": 1 }

class InnerCircle extends FurniturePlacement:

    func enumerate(room) -> Array:
        # Direction mask specifies which sides to put seats on. Bit 0
        # is right side, bit 1 is bottom, etc.
        var direction_masks = [
            15, # Full circle
             3, # Lower right
             6, # Lower left
            12, # Upper right
             9, # Upper left
        ]
        var arr = []
        for strictness in [Strictness.MANY_OTHERS, Strictness.FEW_OTHERS,
                           Strictness.ONLY_CHAIRS, Strictness.ONLY_CHAIRS]:
            for mask in direction_masks:
                arr.append({ "direction_mask": mask, "strictness": strictness })
        return arr

    func value_to_position(value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    func spawn_at(room, value):

        var box = room.box
        var i
        var dir_mask = value['direction_mask']
        var strictness = value['strictness']

        var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)
        var exterior_padding = Util.randi_range(0, 4)
        exterior_padding = min(exterior_padding, min(cells.size.x / 2 - 4, cells.size.y / 2 - 4))

        if exterior_padding == 1 and dir_mask == 15:
            # This combination of parameters pretty much eliminates all edge furniture
            # and leaves an awkward one-cell boundary around the whole edge, so forbid it
            exterior_padding = 0

        cells.position += Vector2(WALL_SIZE + exterior_padding, WALL_SIZE + exterior_padding)
        cells.size -= 2 * Vector2(WALL_SIZE + exterior_padding, WALL_SIZE + exterior_padding)

        var length
        var arr = []
        var pos = cells.position
        var lengthx = cells.size.x
        var lengthy = cells.size.y

        # Top
        if dir_mask & 8:
            i = 1
            while i < lengthx - 1:
                var max_len = max(lengthx - 1 - i, 1)
                var furniture = _Helper._make_furniture(max_len, strictness)
                furniture["object"].set_direction(1)
                furniture["object"].position = 32 * (pos + Vector2(i, 0))
                arr.append(furniture["object"])
                i += furniture["length"]

        # Bottom
        if dir_mask & 2:
            i = 1
            while i < lengthx - 1:
                var max_len = max(lengthx - 1 - i, 1)
                var furniture = _Helper._make_furniture(max_len, strictness)
                furniture["object"].set_direction(3)
                furniture["object"].position = 32 * (pos + Vector2(i, lengthy - 1))
                arr.append(furniture["object"])
                i += furniture["length"]

        # Left
        if dir_mask & 4:
            i = 1
            while i < lengthy - 1:
                var max_len = max(lengthy - 1 - i, 1)
                var furniture = _Helper._make_furniture(max_len, strictness)
                furniture["object"].set_direction(0)
                furniture["object"].position = 32 * (pos + Vector2(0, i))
                arr.append(furniture["object"])
                i += furniture["length"]

        # Right
        if dir_mask & 1:
            i = 1
            while i < lengthy - 1:
                var max_len = max(lengthy - 1 - i, 1)
                var furniture = _Helper._make_furniture(max_len, strictness)
                furniture["object"].set_direction(2)
                furniture["object"].position = 32 * (pos + Vector2(lengthx - 1, i))
                arr.append(furniture["object"])
                i += furniture["length"]

        arr.shuffle()
        return arr
