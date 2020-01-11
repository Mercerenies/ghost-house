extends Node

const StorageRoom = preload("StorageRoom.gd")

# These constants are necessary; see Godot issue #35025
const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE
const _Helper = StorageRoom._Helper

class GarageRandomStorage extends StorageRoom.RegionRandomStorage:

    func get_box_rates() -> Array:
        return [0.90, 0.80, 0.70]

    func get_size() -> Vector2:
        return Vector2(4, 4)
