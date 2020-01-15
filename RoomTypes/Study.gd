extends Node

# TODO Make a custom SpecialPlacementManager for libraries to only
# allow the labyrinth to spawn in big rooms (similar to what we're
# doing in Garage)

const SimpleRows = preload("SimpleRows.gd")

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

class HorizontalRows extends SimpleRows:

    func generate_furniture(value):
        var obj = _Helper._make_furniture(value['strictness'])
        obj["object"].set_direction(1 if randf() < 0.5 else 3)
        return obj

    func get_orientation():
        return SimpleRows.Orientation.HORIZONTAL

    func get_gap_size():
        if randf() < 0.1:
            return 4
        else:
            return 3

    func enumerate(room) -> Array:
        return [
            { "strictness": Strictness.MANY_OTHERS },
            { "strictness": Strictness.FEW_OTHERS },
            { "strictness": Strictness.ONLY_LONG_SHELVES },
            { "strictness": Strictness.ONLY_SHELVES },
        ]

class VerticalRows extends SimpleRows:

    func generate_furniture(value):
        var obj = _Helper._make_furniture(value['strictness'])
        obj["object"].set_direction(0 if randf() < 0.5 else 2)
        return obj

    func get_orientation():
        return SimpleRows.Orientation.VERTICAL

    func get_gap_size():
        if randf() < 0.1:
            return 4
        else:
            return 3

    func enumerate(room) -> Array:
        return [
            { "strictness": Strictness.MANY_OTHERS },
            { "strictness": Strictness.FEW_OTHERS },
            { "strictness": Strictness.ONLY_LONG_SHELVES },
            { "strictness": Strictness.ONLY_SHELVES },
        ]

class Labyrinth extends FurniturePlacement:

    func enumerate(room) -> Array:
        # Placeholder value. It just needs to exist
        return [0]

    func value_to_position(_value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    func spawn_at(room, _value):
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
                horiz.position = 32 * (upperleft + Vector2(1, 0))
                vert.set_direction(0)
                vert.position = 32 * (upperleft + Vector2(0, 1))
                center.set_direction(randi() % 2)
                center.position = 32 * upperleft
                shelves.append(horiz)
                shelves.append(vert)
                shelves.append(center)

        shelves.shuffle()
        return shelves

class PlacementManager extends SpecialPlacementManager:

    func determine_placements(size: Vector2) -> Array:
        var min_dim = min(size.x, size.y)
        var max_dim = max(size.x, size.y)

        if randf() < 0.1 and max_dim >= 3:
            return [Labyrinth.new()]
        elif randf() < 0.2 and min_dim >= 3:
            return [Labyrinth.new()]
        return [HorizontalRows.new() if randf() < 0.5 else VerticalRows.new()]
