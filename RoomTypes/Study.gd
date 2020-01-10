extends Node

const LongBookshelf = preload("res://Furniture/LongBookshelf/LongBookshelf.tscn")
const Bookshelf = preload("res://Furniture/Bookshelf/Bookshelf.tscn")
const Recliner = preload("res://Furniture/Recliner/Recliner.tscn")
const Sofa = preload("res://Furniture/Sofa/Sofa.tscn")
const DeskLamp = preload("res://Furniture/DeskLamp/DeskLamp.tscn")
const FloorLamp = preload("res://Furniture/FloorLamp/FloorLamp.tscn")

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

enum Strictness {
    MANY_OTHERS = 0,
    FEW_OTHERS = 1,
    ONLY_SHELVES = 2,
    ONLY_LONG_SHELVES = 3,
}

# Can't access static functions in an outer scope but can in a class
# that appears in outer scope (??)
class _Helper:

    static func _make_variety_furniture():
        match randi() % 10:
            0:
                return { "object": Sofa.instance(), "length": 2 }
            1, 2, 3:
                return { "object": Recliner.instance(), "length": 1 }
            4, 5, 6:
                return { "object": DeskLamp.instance(), "length": 1 }
            7, 8, 9:
                return { "object": FloorLamp.instance(), "length": 1 }

    static func _make_furniture(strictness):
        if strictness <= Strictness.MANY_OTHERS and randf() < 0.15:
            return _make_variety_furniture()
        if strictness <= Strictness.FEW_OTHERS and randf() < 0.1:
            return _make_variety_furniture()
        if strictness <= Strictness.ONLY_SHELVES and randf() < 0.1:
            return { "object": Bookshelf.instance(), "length": 1 }
        return { "object": LongBookshelf.instance(), "length": 2 }

class HorizontalRows extends FurniturePlacement:

    func enumerate(room) -> Array:
        return [
            {"room": room, "strictness": Strictness.MANY_OTHERS },
            {"room": room, "strictness": Strictness.FEW_OTHERS },
            {"room": room, "strictness": Strictness.ONLY_LONG_SHELVES },
            {"room": room, "strictness": Strictness.ONLY_SHELVES },
        ]

    func value_to_position(value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    func spawn_at(value):
        var room = value['room']
        var box = room.box

        var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)
        cells.position += Vector2(WALL_SIZE, WALL_SIZE)
        cells.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)

        var shelves = []

        var pos = cells.position
        var xvel = 1
        var yvel = 3
        if randf() < 0.1:
            yvel = 4

        if randf() < 0.5:
            pos.x = cells.end.x - 1
            xvel *= -1

        pos += Vector2(sign(xvel) * (randi() % 2), randi() % 3)

        while pos.y < cells.end.y:
            var choice = _Helper._make_furniture(value['strictness'])
            var obj = choice['object']
            obj.position = pos * 32
            obj.set_direction(1)
            shelves.append({ "object": obj, "position": pos })
            pos.x += choice['length'] * xvel
            if xvel > 0:
                if pos.x >= cells.end.x:
                    pos.y += yvel
                    xvel *= -1
            else:
                if pos.x < cells.position.x:
                    pos.y += yvel
                    xvel *= -1

        shelves.shuffle()
        return shelves

class VerticalRows extends FurniturePlacement:

    func enumerate(room) -> Array:
        return [
            {"room": room, "strictness": Strictness.MANY_OTHERS },
            {"room": room, "strictness": Strictness.FEW_OTHERS },
            {"room": room, "strictness": Strictness.ONLY_LONG_SHELVES },
            {"room": room, "strictness": Strictness.ONLY_SHELVES },
        ]

    func value_to_position(value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    func spawn_at(value):
        var room = value['room']
        var box = room.box

        var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)
        cells.position += Vector2(WALL_SIZE, WALL_SIZE)
        cells.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)

        var shelves = []

        var pos = cells.position
        var yvel = 1
        var xvel = 3
        if randf() < 0.1:
            xvel = 4

        if randf() < 0.5:
            pos.y = cells.end.y - 1
            yvel *= -1

        pos += Vector2(randi() % 3, sign(yvel) * (randi() % 2))

        while pos.x < cells.end.x:
            var choice = _Helper._make_furniture(value['strictness'])
            var obj = choice['object']
            obj.position = pos * 32
            obj.set_direction(0)
            shelves.append({ "object": obj, "position": pos })
            pos.y += choice['length'] * yvel
            if yvel > 0:
                if pos.y >= cells.end.y:
                    pos.x += xvel
                    yvel *= -1
            else:
                if pos.y < cells.position.y:
                    pos.x += xvel
                    yvel *= -1

        shelves.shuffle()
        return shelves

class Labyrinth extends FurniturePlacement:

    func enumerate(room) -> Array:
        return [{"room": room}]

    func value_to_position(value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    func spawn_at(value):
        var room = value['room']
        var box = room.box
        var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)

        var shelves = []
        for i in range(0, cells.size.x, 3):
            for j in range(0, cells.size.y, 3):
                var upperleft = cells.position + Vector2(i, j)
                var horiz = LongBookshelf.instance()
                var vert = LongBookshelf.instance()
                var center = Bookshelf.instance()
                horiz.set_direction(1)
                vert.set_direction(0)
                center.set_direction(randi() % 2)
                shelves.append({ "object": horiz, "position": upperleft + Vector2(1, 0) })
                shelves.append({ "object": vert, "position": upperleft + Vector2(0, 1) })
                shelves.append({ "object": center, "position": upperleft })

        shelves.shuffle()
        return shelves
