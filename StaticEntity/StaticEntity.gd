extends Entity
class_name StaticEntity

const OOB_CELL = Vector2(-2048, -2048)

export var dims: Vector2 = Vector2(1, 1)

var cell: Vector2

func position_self() -> void:
    var current_cell = Vector2(floor(position.x / 32), floor(position.y / 32))
    for i in range(dims.x):
        for j in range(dims.y):
            get_room().set_entity_cell(current_cell + Vector2(i, j), self)
    cell = current_cell

func unposition_self() -> void:
    for i in range(dims.x):
        for j in range(dims.y):
            get_room().set_entity_cell(cell + Vector2(i, j), null)
    cell = OOB_CELL

func is_positioned() -> bool:
    return cell != OOB_CELL

func set_dims(vec: Vector2) -> void:
    dims = vec

func get_dims() -> Vector2:
    return dims
