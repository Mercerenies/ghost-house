extends Node

const Sofa = preload("res://Furniture/Sofa/Sofa.tscn")
const Recliner = preload("res://Furniture/Recliner/Recliner.tscn")
const DeskLamp = preload("res://Furniture/DeskLamp/DeskLamp.tscn")
const FloorLamp = preload("res://Furniture/FloorLamp/FloorLamp.tscn")
const Dresser = preload("res://Furniture/Dresser/Dresser.tscn")
const Bench = preload("res://Furniture/Bench/Bench.tscn")
const LongCabinet = preload("res://Furniture/LongCabinet/LongCabinet.tscn")
const Cabinet = preload("res://Furniture/Cabinet/Cabinet.tscn")
const Wardrobe = preload("res://Furniture/Wardrobe/Wardrobe.tscn")

const InnerCircle = preload("InnerCircle.gd")

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

enum Strictness {
    MANY_OTHERS = 0,
    FEW_OTHERS = 1,
    ONLY_DRESSERS = 2,
}

class _Helper:

    static func _make_variety_furniture(max_len):
        match randi() % 5:
            0:
                return { "object": DeskLamp.instance(), "length": 1 }
            1:
                if max_len <= 1:
                    return { "object": FloorLamp.instance(), "length": 1 }
                return { "object": Bench.instance(), "length": 2 }
            2:
                return { "object": FloorLamp.instance(), "length": 1 }
            3:
                if max_len <= 1:
                    return { "object": Recliner.instance(), "length": 1 }
                return { "object": Sofa.instance(), "length": 2 }
            4:
                return { "object": Recliner.instance(), "length": 1 }

    static func _make_furniture(max_len, strictness):
        if strictness <= Strictness.MANY_OTHERS and randf() < 0.2:
            return _make_variety_furniture(max_len)
        if strictness <= Strictness.FEW_OTHERS and randf() < 0.1:
            return _make_variety_furniture(max_len)
        match randi() % 4:
            0:
                if max_len <= 1:
                    return { "object": Cabinet.instance(), "length": 1 }
                return { "object": Dresser.instance(), "length": 2 }
            1:
                return { "object": Cabinet.instance(), "length": 1 }
            2:
                if max_len <= 1:
                    return { "object": Wardrobe.instance(), "length": 1 }
                return { "object": LongCabinet.instance(), "length": 2 }
            3:
                return { "object": Wardrobe.instance(), "length": 1 }

class RoomInnerCircle extends InnerCircle:

    func direction_masks() -> Array:
        return [
            15, # Full circle
             7, # All except top
            11, # All except left
            14, # All except right
            13, # All except bottom
        ]

    func determine_params():
        var strictness = Util.choose([Strictness.MANY_OTHERS, Strictness.FEW_OTHERS,
                                      Strictness.FEW_OTHERS, Strictness.ONLY_DRESSERS])
        return { "strictness": strictness }

    func determine_exterior_padding() -> int:
        return Util.randi_range(0, 4)

    func determine_starting_offset() -> int:
        return 1

    func generate_furniture(max_len, params):
        var strictness = params["strictness"]
        return _Helper._make_furniture(max_len, strictness)
