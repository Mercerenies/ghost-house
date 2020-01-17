extends Node

const SimpleRows = preload("SimpleRows.gd")

const ClothesRack = preload("res://Furniture/ClothesRack/ClothesRack.tscn")
const DeskLamp = preload("res://Furniture/DeskLamp/DeskLamp.tscn")
const FloorLamp = preload("res://Furniture/FloorLamp/FloorLamp.tscn")
const Bench = preload("res://Furniture/Bench/Bench.tscn")
const DiningChair = preload("res://Furniture/DiningChair/DiningChair.tscn")
const CardboardBox = preload("res://Furniture/CardboardBox/CardboardBox.tscn")
const LaundryBasket = preload("res://Furniture/LaundryBasket/LaundryBasket.tscn")

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

enum Strictness {
    MANY_OTHERS = 0,
    FEW_OTHERS = 1,
    ONLY_RACKS = 2,
}

# Can't access static functions in an outer scope but can in a class
# that appears in outer scope (??)
class _Helper:

    static func _make_variety_furniture():
        match randi() % 12:
            0, 1:
                return { "object": DeskLamp.instance(), "length": 1 }
            2, 3, 4:
                return { "object": FloorLamp.instance(), "length": 1 }
            5, 6, 7:
                return { "object": Bench.instance(), "length": 2 }
            8, 9, 10:
                return { "object": DiningChair.instance(), "length": 1 }
            11:
                return { "object": CardboardBox.instance(), "length": 1 }
            12:
                return { "object": LaundryBasket.instance(), "length": 1 }

    static func _make_furniture(strictness):
        if strictness <= Strictness.MANY_OTHERS and randf() < 0.15:
            return _make_variety_furniture()
        if strictness <= Strictness.FEW_OTHERS and randf() < 0.1:
            return _make_variety_furniture()
        return { "object": ClothesRack.instance(), "length": 2 }

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
            { "strictness": Strictness.ONLY_RACKS },
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
            { "strictness": Strictness.ONLY_RACKS },
        ]
