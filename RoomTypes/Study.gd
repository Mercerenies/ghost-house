extends Node

const LongBookshelf = preload("res://Furniture/LongBookshelf/LongBookshelf.tscn")

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

class HorizontalRows extends FurniturePlacement:

    func enumerate(room) -> Array:
        # For right now, just one value. We may allow customization on this later.
        return [{"room": room}]

    func value_to_position(value) -> Rect2:
        return GeneratorData.PLACEMENT_SAFE

    func spawn_at(value):
        var room = value['room']
        var box = room.box

        var cells = Rect2(box.position * TOTAL_CELL_SIZE, box.size * TOTAL_CELL_SIZE)
        cells.position += Vector2(WALL_SIZE, WALL_SIZE)
        cells.size -= 2 * Vector2(WALL_SIZE, WALL_SIZE)

        var shelves = []

        var pos = cells.position
        pos += Vector2(randi() % 2, randi() % 3)
        var vel = 2
        while pos.y < cells.end.y:
            var obj = LongBookshelf.instance()
            obj.position = pos * 32
            obj.set_direction(1)
            shelves.append({ "object": obj, "position": pos })
            pos.x += vel
            if vel > 0:
                if pos.x >= cells.end.x:
                    pos.y += 3
                    vel *= -1
            else:
                if pos.x < cells.position.x:
                    pos.y += 3
                    vel *= -1

        shelves.shuffle()
        return shelves
