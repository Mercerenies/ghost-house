extends Node

const BathroomCounter = preload("res://Furniture/BathroomCounter/BathroomCounter.tscn")
const BathroomSink = preload("res://Furniture/BathroomSink/BathroomSink.tscn")
const Toilet = preload("res://Furniture/Toilet/Toilet.tscn")
const LaundryBasket = preload("res://Furniture/LaundryBasket/LaundryBasket.tscn")

const SimpleRows = preload("SimpleRows.gd")
const Orientation = SimpleRows.Orientation

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

enum Strictness {
    FEW_OTHERS = 0,
    SINKS_AND_COUNTERS = 1,
}

class _Helper:

    static func _make_furniture(strictness):
        if randf() < 0.1 and strictness <= Strictness.FEW_OTHERS:
            return { "object": Toilet.instance(), "length": 1 }
        if randf() < 0.1 and strictness <= Strictness.FEW_OTHERS:
            return { "object": LaundryBasket.instance(), "length": 1 }
        if randf() < 0.5:
            return { "object": BathroomCounter.instance(), "length": 2 }
        else:
            return { "object": BathroomSink.instance(), "length": 2 }

class BarAcross extends FurniturePlacement:

    func enumerate(room) -> Array:
        var upperleft = room.box.position * TOTAL_CELL_SIZE
        var pos

        var arr = []

        # Vertical options
        pos = upperleft + TOTAL_CELL_SIZE * Vector2(1, 0)
        # warning-ignore: integer_division
        while pos.x + CELL_SIZE / 2 < room.box.end.x * TOTAL_CELL_SIZE:
            for offset in [Vector2(0, -1), Vector2()]:
                for strictness in [Strictness.FEW_OTHERS, Strictness.SINKS_AND_COUNTERS]:
                    arr.append({ "strictness": strictness,
                                 "orientation": Orientation.VERTICAL,
                                 "position": pos + offset })
            pos.x += TOTAL_CELL_SIZE

        # Horizontal options
        pos = upperleft + TOTAL_CELL_SIZE * Vector2(0, 1)
        # warning-ignore: integer_division
        while pos.y + CELL_SIZE / 2 < room.box.end.y * TOTAL_CELL_SIZE:
            for offset in [Vector2(-1, 0), Vector2()]:
                for strictness in [Strictness.FEW_OTHERS, Strictness.SINKS_AND_COUNTERS]:
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
