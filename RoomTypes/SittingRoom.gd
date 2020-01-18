extends Node

const Sofa = preload("res://Furniture/Sofa/Sofa.tscn")
const Recliner = preload("res://Furniture/Recliner/Recliner.tscn")
const DeskLamp = preload("res://Furniture/DeskLamp/DeskLamp.tscn")
const FloorLamp = preload("res://Furniture/FloorLamp/FloorLamp.tscn")

const InnerCircle = preload("InnerCircle.gd")

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

class RoomInnerCircle extends InnerCircle:

    func direction_masks() -> Array:
        return [
            15, # Full circle
             3, # Lower right
             6, # Lower left
            12, # Upper right
             9, # Upper left
        ]

    func determine_params():
        var strictness = Util.choose([Strictness.MANY_OTHERS, Strictness.FEW_OTHERS,
                                      Strictness.ONLY_CHAIRS, Strictness.ONLY_CHAIRS])
        return { "strictness": strictness }

    func determine_exterior_padding() -> int:
        return Util.randi_range(0, 4)

    func determine_starting_offset() -> int:
        return 1

    func generate_furniture(max_len, params):
        var strictness = params["strictness"]
        return _Helper._make_furniture(max_len, strictness)
