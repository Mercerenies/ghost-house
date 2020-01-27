extends Node

const LaundryMachine = preload("res://Furniture/LaundryMachine/LaundryMachine.tscn")
const Dryer = preload("res://Furniture/Dryer/Dryer.tscn")
const ClothesRack = preload("res://Furniture/ClothesRack/ClothesRack.tscn")
const LaundryBasket = preload("res://Furniture/LaundryBasket/LaundryBasket.tscn")

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

enum Strictness {
    FEW_OTHERS = 0,
    WASHERS_AND_DRYERS = 1,
}

class _Helper:

    static func _make_furniture(strictness):
        if randf() < 0.1 and strictness <= Strictness.FEW_OTHERS:
            match randi() % 2:
                0:
                    return { "object": LaundryBasket.instance(), "length": 1 }
                1:
                    return { "object": ClothesRack.instance(), "length": 2 }
        if randf() < 0.5:
            return { "object": LaundryMachine.instance(), "length": 1 }
        else:
            return { "object": Dryer.instance(), "length": 1 }

class CentralBar extends FurniturePlacement:

    func enumerate(room) -> Array:
        if min(room.box.size.x, room.box.size.y) <= 1:
            # Don't attempt this in a 1 x * room
            return []
        # Mask has bit 0 set for horizontal line, bit 1 for vertical
        var arr = []
        for mask in range(0, 4):
            arr.append({ "strictness": Strictness.FEW_OTHERS, "mask": mask })
            arr.append({ "strictness": Strictness.WASHERS_AND_DRYERS, "mask": mask })
        return arr

    func value_to_position(value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    func spawn_at(room, value, cb):

        var box = room.box
        var strictness = value['strictness']
        var mask = value['mask']

        var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)

        cells.position += Vector2(WALL_SIZE, WALL_SIZE)
        cells.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)

        var arr = []
        var i
        var j

        # Horizontal Line
        if mask & 1:
            i = 0
            j = int(cells.size.y / 2) - 1
            while i < cells.size.x:
                var furn = _Helper._make_furniture(strictness)
                furn["object"].set_direction(3)
                furn["object"].position = 32 * (cells.position + Vector2(i, j))
                arr.append(furn["object"])
                i += furn["length"]
            i = 0
            j += 1
            while i < cells.size.x:
                var furn = _Helper._make_furniture(strictness)
                furn["object"].set_direction(1)
                furn["object"].position = 32 * (cells.position + Vector2(i, j))
                arr.append(furn["object"])
                i += furn["length"]

        # Vertical Line
        if mask & 2:
            i = int(cells.size.x / 2) - 1
            j = 0
            while j < cells.size.x:
                var furn = _Helper._make_furniture(strictness)
                furn["object"].set_direction(2)
                furn["object"].position = 32 * (cells.position + Vector2(i, j))
                arr.append(furn["object"])
                j += furn["length"]
            i += 1
            j = 0
            while j < cells.size.x:
                var furn = _Helper._make_furniture(strictness)
                furn["object"].set_direction(0)
                furn["object"].position = 32 * (cells.position + Vector2(i, j))
                arr.append(furn["object"])
                j += furn["length"]

        arr.shuffle()
        for obj in arr:
            cb.call(obj)
