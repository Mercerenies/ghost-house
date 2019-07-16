extends Node2D
class_name MobileEntity

export(float) var speed: float = 128.0 # Pixels / sec

var cell: Vector2
var target_pos: Vector2

func get_room():
    return get_parent()

func can_move_to(dest: Vector2) -> bool:
    var room = get_room()
    return room.get_entity_cell(dest) == null and not room.is_wall_at(dest)

func try_move_to(dest: Vector2) -> bool:
    if can_move_to(dest):
        get_room().move_entity(cell, dest)
        cell = dest
        target_pos = cell * 32
        return true
    return false

func _ready() -> void:
    var current_cell = Vector2(floor(position.x / 32), floor(position.y / 32))
    get_room().set_entity_cell(current_cell, self)
    cell = current_cell
    target_pos = position

func _process(delta: float) -> void:
    if (target_pos - position).length() < speed * delta:
        position = target_pos
    else:
        position += (target_pos - position).normalized() * speed * delta
