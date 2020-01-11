extends Node

const StorageRoom = preload("StorageRoom.gd")

class GarageRandomStorage extends StorageRoom.RegionRandomStorage:

    func get_box_rates() -> Array:
        return [0.90, 0.80, 0.70]

    func get_size() -> Vector2:
        return Vector2(4, 4)
