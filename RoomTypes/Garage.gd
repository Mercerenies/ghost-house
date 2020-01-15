extends Node

const StorageRoom = preload("StorageRoom.gd")
const SimpleRows = preload("SimpleRows.gd")

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

# TODO Can this be consolidated into a common base class with
# SittingRoom.InnerCircle?
class CarsAgainstWall extends FurniturePlacement:

    func enumerate(room) -> Array:
        # Direction mask specifies which sides to put seats on. Bit 0
        # is right side, bit 1 is bottom, etc.
        var direction_masks = [
             1, # Right
             2, # Bottom
             4, # Left
             8, # Top
             5, # Right / Left
            10, # Top / Bottom
        ]

        var arr = []
        for mask in direction_masks:
            arr.append({ "direction_mask": mask })
        return arr

    func value_to_position(value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    func spawn_at(room, value, cb):
        var dir = randi() % 4

        var cells = Rect2(room.box.position * TOTAL_CELL_SIZE, room.box.size * TOTAL_CELL_SIZE)
        cells.position += Vector2(WALL_SIZE, WALL_SIZE)
        cells.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)

        var dir_mask = value['direction_mask']
        var off_by_one = (randf() < 0.5)
        var index = -1
        if randf() < 0.25:
            index = randi() % TYPES_OF_CARS
        var spawner = CarSpawner.new(0.15, index)

        var arr = []

        if dir_mask & 1:
            # Right
            var i = 0
            if off_by_one:
                i += 1
            while i < cells.size.y - 1:
                var furn = spawner.generate_furniture()
                if furn != null:
                    furn.set_direction(dir)
                    furn.position = 32 * (cells.position + Vector2(cells.size.x - 2, i))
                    arr.append(furn)
                i += 2

        if dir_mask & 2:
            # Bottom
            var i = 0
            if off_by_one:
                i += 1
            while i < cells.size.x - 1:
                var furn = spawner.generate_furniture()
                if furn != null:
                    furn.set_direction(dir)
                    furn.position = 32 * (cells.position + Vector2(i, cells.size.y - 2))
                    arr.append(furn)
                i += 2

        if dir_mask & 4:
            # Left
            var i = 0
            if off_by_one:
                i += 1
            while i < cells.size.y - 1:
                var furn = spawner.generate_furniture()
                if furn != null:
                    furn.set_direction(dir)
                    furn.position = 32 * (cells.position + Vector2(0, i))
                    arr.append(furn)
                i += 2

        if dir_mask & 8:
            # Top
            var i = 0
            if off_by_one:
                i += 1
            while i < cells.size.x - 1:
                var furn = spawner.generate_furniture()
                if furn != null:
                    furn.position = 32 * (cells.position + Vector2(i, 0))
                    arr.append(furn)
                i += 2

        # Shuffling is currently mostly unproductive as the cars are
        # all against a wall and thus aren't fighting for control over
        # room space like, say, bookshelves in the middle of a room
        # would. This may change. Watch this space.

        #arr.shuffle()
        for obj in arr:
            cb.call(obj)

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

    func enumerate(room) -> Array:
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

    func enumerate(room) -> Array:
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
                        result.append(HorizontalRows.new() if randf() < 0.5 else VerticalRows.new())
            for _i in range(2):
                if randf() < 0.25:
                    result.append(RandomStorage.new())
            return result
