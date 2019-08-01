extends Entity
class_name StaticEntity

export var dims: Vector2 = Vector2(1, 1)

var cell: Vector2

func position_self() -> void:
    var current_cell = Vector2(floor(position.x / 32), floor(position.y / 32))
    for i in range(dims.x):
        for j in range(dims.y):
            get_room().set_entity_cell(current_cell + Vector2(i, j), self)
    cell = current_cell
