extends Node

const StorageRoom = preload("StorageRoom.gd")
const SimpleRows = preload("SimpleRows.gd")
const InnerCircle = preload("InnerCircle.gd")

const Automobile = preload("res://Furniture/Automobile/Automobile.tscn")
const AutomobilePlacement = preload("res://Furniture/Automobile/AutomobilePlacement.gd")

const TYPES_OF_CARS = 4 # TODO Put this constant somewhere more appropriate

# These constants are necessary; see Godot issue #35025
const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE
const _Helper = StorageRoom._Helper

class CarSpawner extends Reference:
    var _failure_chance: float
    var _image_index: int

    func _init(failure_chance: float, image_index: int = -1):
        _failure_chance = failure_chance
        _image_index = image_index

    func generate_furniture():
        if randf() < _failure_chance:
            return null
        var result = Automobile.instance()
        result.set_image_type(_image_index)
        return result

class RandomStorage extends StorageRoom.RegionRandomStorage:

    func get_box_rates() -> Array:
        return [0.90, 0.80, 0.70]

    func get_size() -> Vector2:
        return Vector2(4, 4)

class CarsAgainstWall extends InnerCircle:

    func direction_masks() -> Array:
        return [
             1, # Right
             2, # Bottom
             4, # Left
             8, # Top
             5, # Right / Left
            10, # Top / Bottom
        ]

    func determine_params():
        var index = -1
        if randf() < 0.25:
            index = randi() % TYPES_OF_CARS
        var spawner = CarSpawner.new(0.15, index)
        var dir = randi() % 4
        return { "spawner": spawner, "direction": dir }

    func determine_exterior_padding() -> int:
        return 0

    func determine_starting_offset() -> int:
        return 0 if randf() < 0.5 else 1

    func generate_furniture(_max_len, params):
        var furniture = params["spawner"].generate_furniture()
        return { "object": furniture,
                 "length": 2 }

    func set_furniture_direction(obj, _dir, params):
        # Enforce that all cars face the same way
        obj.set_direction(params["direction"])

    func get_short_edge() -> int:
        return 2

class HorizontalRows extends SimpleRows:

    func generate_furniture(value):
        var obj = value["spawner"].generate_furniture()
        obj.set_direction(value["dir"])
        return { "object": obj, "length": 2 }

    func get_orientation():
        return SimpleRows.Orientation.HORIZONTAL

    func get_gap_size():
        var r = randf()
        if r < 0.1:
            return 6
        elif r < 0.15:
            return 4
        else:
            return 5

    func spawn_prologue(value):
        var index = -1
        if randf() < 0.25:
            index = randi() % TYPES_OF_CARS
        value["spawner"] = CarSpawner.new(0.00, index)

    func enumerate(_room) -> Array:
        var arr = []
        for dir in range(4):
            arr.append({ "dir": dir })
        return arr

class VerticalRows extends SimpleRows:

    func generate_furniture(value):
        var obj = value["spawner"].generate_furniture()
        obj.set_direction(value["dir"])
        return { "object": obj, "length": 2 }

    func get_orientation():
        return SimpleRows.Orientation.VERTICAL

    func get_gap_size():
        var r = randf()
        if r < 0.1:
            return 6
        elif r < 0.15:
            return 4
        else:
            return 5

    func spawn_prologue(value):
        var index = -1
        if randf() < 0.25:
            index = randi() % TYPES_OF_CARS
        value["spawner"] = CarSpawner.new(0.00, index)

    func enumerate(_room) -> Array:
        var arr = []
        for dir in range(4):
            arr.append({ "dir": dir })
        return arr

class PlacementManager extends SpecialPlacementManager:

    func determine_placements(size: Vector2) -> Array:
        var min_dim = min(size.x, size.y)
        var max_dim = max(size.x, size.y)

        if max_dim <= 2:
            # Small room so favor small setups
            var result = []
            for _i in range(3):
                if randf() < 0.25:
                    result.append(RandomStorage.new())
            match randi() % 4:
                0:
                    result.append(RandomStorage.new())
                1:
                    result.append(AutomobilePlacement.new())
                2:
                    result.append(AutomobilePlacement.new())
                    result.append(AutomobilePlacement.new())
                3:
                    result.append(CarsAgainstWall.new())
            return result
        else:
            # Larger room
            var result = []
            for _i in range(2):
                if randf() < 0.25:
                    result.append(RandomStorage.new())
            match randi() % 7:
                0, 1, 2:
                    result.append(HorizontalRows.new())
                3, 4, 5:
                    result.append(VerticalRows.new())
                6:
                    if min_dim <= 2:
                        result.append(CarsAgainstWall.new())
                    else:
                        # What does this warning mean (???)
                        # warning-ignore: incompatible_ternary
                        result.append(HorizontalRows.new() if randf() < 0.5 else VerticalRows.new())
            for _i in range(2):
                if randf() < 0.25:
                    result.append(RandomStorage.new())
            return result
