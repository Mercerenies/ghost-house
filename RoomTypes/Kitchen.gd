extends Node

const KitchenCounter = preload("res://Furniture/KitchenCounter/KitchenCounter.tscn")
const KitchenSink = preload("res://Furniture/KitchenSink/KitchenSink.tscn")
const Dishwasher = preload("res://Furniture/Dishwasher/Dishwasher.tscn")
const Stove = preload("res://Furniture/Stove/Stove.tscn")

const SimpleRows = preload("SimpleRows.gd")
const Orientation = SimpleRows.Orientation

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

# Strictness argument is currently unused, but it's here anyway if I
# want to use it later.
enum Strictness {
    DEFAULT = 0,
}

class _Helper:

    static func _make_furniture(strictness):
        match randi() % 6:
            0, 1:
                return { "object": KitchenCounter.instance(), "length": 2 }
            2, 3:
                return { "object": KitchenSink.instance(), "length": 2 }
            4:
                return { "object": Dishwasher.instance(), "length": 1 }
            5:
                return { "object": Stove.instance(), "length": 1 }

class BarAcross extends FurniturePlacement:

    func enumerate(room) -> Array:
        var upperleft = room.box.position * TOTAL_CELL_SIZE
        var pos

        var arr = []

        # Vertical options
        pos = upperleft + TOTAL_CELL_SIZE * Vector2(1, 0)
        while pos.x + CELL_SIZE / 2 < room.box.end.x * TOTAL_CELL_SIZE:
            for offset in [Vector2(0, -1), Vector2()]:
                for strictness in [Strictness.DEFAULT]:
                    arr.append({ "strictness": strictness,
                                 "orientation": Orientation.VERTICAL,
                                 "position": pos + offset })
            pos.x += TOTAL_CELL_SIZE

        # Horizontal options
        pos = upperleft + TOTAL_CELL_SIZE * Vector2(0, 1)
        while pos.y + CELL_SIZE / 2 < room.box.end.y * TOTAL_CELL_SIZE:
            for offset in [Vector2(-1, 0), Vector2()]:
                for strictness in [Strictness.DEFAULT]:
                    arr.append({ "strictness": strictness,
                                 "orientation": Orientation.HORIZONTAL,
                                 "position": pos + offset })
            pos.y += TOTAL_CELL_SIZE

        return arr

    func value_to_position(_value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    static func _decide_direction(orientation):
        if orientation == Orientation.HORIZONTAL:
            return 1 if randf() < 0.5 else 3
        else:
            return 0 if randf() < 0.5 else 2

    func spawn_at(room, value, cb):

        var box = room.box
        var strictness = value['strictness']
        var orientation = value['orientation']
        var position = value['position']

        var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)

        cells.position += Vector2(WALL_SIZE, WALL_SIZE)
        cells.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)

        var dir = Vector2(1, 0) if orientation == Orientation.HORIZONTAL else Vector2(0, 1)

        var arr = []
        while position.x < cells.end.x and position.y < cells.end.y:
            var furn = _Helper._make_furniture(strictness)
            var obj = furn['object']
            var length = furn['length']
            obj.position = 32 * position
            obj.set_direction(_decide_direction(orientation))
            arr.append(obj)
            position += length * dir

        arr.shuffle()
        for obj in arr:
            cb.call(obj)
