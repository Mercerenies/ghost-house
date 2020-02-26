extends Entity
class_name MobileEntity

enum Dir {
    RIGHT = 0, DOWN, LEFT, UP
}

export(float) var speed: float = 120.0 # Pixels / sec
export(Texture) var texture: Texture = null
export(Color) var color: Color = Color.white
var sprite: Sprite = null
var timer: Timer = null

var cell: Vector2
var target_pos: Vector2

var _dir: int = Dir.DOWN
var _image_index: int = 0

func set_direction(dir: int) -> void:
    _dir = dir

func get_direction() -> int:
    return _dir

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

func position_self() -> void:
    var current_cell = Vector2(floor(get_position().x / 32), floor(get_position().y / 32))
    get_room().set_entity_cell(current_cell, self)
    cell = current_cell
    target_pos = get_position()

func unposition_self() -> void:
    get_room().set_entity_cell(cell, null)
    cell = Vector2(-999, -999)

func _ready() -> void:

    sprite = Sprite.new()
    add_child(sprite)
    sprite.texture = texture
    sprite.modulate = color
    sprite.hframes = 4
    sprite.vframes = 4
    sprite.frame = 0
    sprite.position = Vector2(16, 16)

    timer = Timer.new()
    add_child(timer)
    var conn_result = timer.connect("timeout", self, "_on_Timer_timeout")
    assert(conn_result == OK)
    timer.wait_time = 0.1
    timer.start()

func _move_toward_target(max_distance: float) -> float:
    if (target_pos - get_position()).length() <= max_distance:
        set_position(target_pos)
        return max_distance - (target_pos - get_position()).length()
    else:
        set_position(get_position() + (target_pos - get_position()).normalized() * max_distance)
        return 0.0

func _process_movement(_delta: float) -> void:
    pass

func _process(delta: float) -> void:
    sprite.frame = get_direction() * 4
    if get_position() != target_pos:
        sprite.frame += _image_index

    _process_movement(delta)
    var _movement_left = _move_toward_target(speed * delta)
    # TODO Use this movement_left
    #_process_movement(delta)
    #_move_toward_target(movement_left)
    #_process_movement(delta)

func _on_Timer_timeout() -> void:
    _image_index = (_image_index + 1) % 4

func get_sprite() -> Sprite:
    return sprite
