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
    var current_cell = Vector2(floor(position.x / 32), floor(position.y / 32))
    get_room().set_entity_cell(current_cell, self)
    cell = current_cell
    target_pos = position

func unposition_self() -> void:
    get_room().set_entity_cell(cell, null)
    cell = Vector2(-999, -999)

func _ready() -> void:

    sprite = Sprite.new()
    add_child(sprite)
    sprite.texture = texture
    sprite.hframes = 4
    sprite.vframes = 4
    sprite.frame = 0
    sprite.position = Vector2(16, 16)

    timer = Timer.new()
    add_child(timer)
    timer.connect("timeout", self, "_on_Timer_timeout")
    timer.wait_time = 0.1
    timer.start()

func _process(delta: float) -> void:
    sprite.frame = get_direction() * 4
    if position != target_pos:
        sprite.frame += _image_index

    if (target_pos - position).length() <= speed * delta:
        position = target_pos
    else:
        position += (target_pos - position).normalized() * speed * delta

func _on_Timer_timeout() -> void:
    _image_index = (_image_index + 1) % 4

func get_sprite() -> Sprite:
    return sprite
