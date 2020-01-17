extends Node

const LongBookshelf = preload("res://Furniture/LongBookshelf/LongBookshelf.tscn")
const Bookshelf = preload("res://Furniture/Bookshelf/Bookshelf.tscn")
const LaundryMachine = preload("res://Furniture/LaundryMachine/LaundryMachine.tscn")
const Dryer = preload("res://Furniture/Dryer/Dryer.tscn")
const Sofa = preload("res://Furniture/Sofa/Sofa.tscn")
const Recliner = preload("res://Furniture/Recliner/Recliner.tscn")
const DiningChair = preload("res://Furniture/DiningChair/DiningChair.tscn")
const OfficeChair = preload("res://Furniture/OfficeChair/OfficeChair.tscn")
const Cabinet = preload("res://Furniture/Cabinet/Cabinet.tscn")
const LongCabinet = preload("res://Furniture/LongCabinet/LongCabinet.tscn")
const Dresser = preload("res://Furniture/Dresser/Dresser.tscn")
const FloorLamp = preload("res://Furniture/FloorLamp/FloorLamp.tscn")
const DeskLamp = preload("res://Furniture/DeskLamp/DeskLamp.tscn")
const Bench = preload("res://Furniture/Bench/Bench.tscn")
const CardboardBox = preload("res://Furniture/CardboardBox/CardboardBox.tscn")
const Wardrobe = preload("res://Furniture/Wardrobe/Wardrobe.tscn")
const ClothesRack = preload("res://Furniture/ClothesRack/ClothesRack.tscn")
const Workbench = preload("res://Furniture/Workbench/Workbench.tscn")
const LaundryBasket = preload("res://Furniture/LaundryBasket/LaundryBasket.tscn")

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

const FURNITURE = [LongBookshelf, Bookshelf, LaundryMachine, Dryer,
                   Sofa, Recliner, DiningChair, OfficeChair, Cabinet,
                   LongCabinet, Dresser, FloorLamp, DeskLamp, Bench,
                   CardboardBox, Wardrobe, ClothesRack, Workbench,
                   LaundryBasket]

class _Helper:

    static func _make_furniture(box_rate):
        if randf() < box_rate:
            return CardboardBox.instance()
        return Util.choose(FURNITURE).instance()

# Generates a bunch of random stuff scattered throughout, with no
# regard for organization. Useful for storage rooms where it's
# supposed to look like things are just sitting there collecting dust.
class RandomStorage extends FurniturePlacement:

    func should_reserve_placement():
        return false

    func value_to_position(value):
        if should_reserve_placement():
            return value['region']
        else:
            return GeneratorData.PLACEMENT_SAFE

    func spawn_at(_room, value, cb):
        var region = value['region']
        var box_rate = value['box_rate']

        var arr = []
        for i in range(region.position.x, region.end.x):
            for j in range(region.position.y, region.end.y):
                var furn = _Helper._make_furniture(box_rate)
                furn.set_direction(randi() % 4)
                furn.position = 32 * Vector2(i, j)
                arr.append(furn)

        arr.shuffle()
        for obj in arr:
            cb.call(obj)

class FullRoomRandomStorage extends RandomStorage:

    func should_reserve_placement():
        return false

    func enumerate(room) -> Array:
        var box = room.box
        var bounds = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)
        bounds.position += Vector2(WALL_SIZE, WALL_SIZE)
        bounds.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)
        return [
            { "region": bounds, "box_rate": 0.85 },
            { "region": bounds, "box_rate": 0.50 },
            { "region": bounds, "box_rate": 0.00 },
        ]

class RegionRandomStorage extends RandomStorage:

    func should_reserve_placement():
        return true

    func get_box_rates() -> Array:
        return [0.85, 0.50, 0.00]

    func get_size() -> Vector2:
        return Vector2(3, 3)

    func enumerate(room) -> Array:
        var box = room.box
        var bounds = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)
        bounds.position += Vector2(WALL_SIZE, WALL_SIZE)
        bounds.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)
        var box_rates = get_box_rates()
        var dims = get_size()

        var arr = []
        for i in range(bounds.position.x, bounds.end.x - dims.x):
            for j in range(bounds.position.y, bounds.end.y - dims.y):
                for rate in box_rates:
                    arr.append({ "region": Rect2(Vector2(i, j), dims),
                                 "box_rate": rate })
        return arr
