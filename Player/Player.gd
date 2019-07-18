extends MobileEntity

func _ready():
    $Sprite.visible = false

func _input_dir_to_dir(v: Vector2) -> int:
    if v == Vector2(1, 0):
        return Dir.RIGHT
    elif v == Vector2(0, 1):
        return Dir.DOWN
    elif v == Vector2(-1, 0):
        return Dir.LEFT
    elif v == Vector2(0, -1):
        return Dir.UP
    return -1

func get_input_direction() -> Vector2:
    var vec = Vector2(
        int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
        int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
    )
    if vec.x != 0:
        vec.y = 0
    return vec

func _can_move_at_all() -> bool:
    if position != target_pos:
        return false
    if get_room().is_showing_modal():
        return false
    return true

func can_move_to(pos: Vector2) -> bool:
    if not _can_move_at_all():
        return false
    return .can_move_to(pos)

func _process(delta: float) -> void:
    var input_dir = get_input_direction()
    if _can_move_at_all():
        if input_dir != Vector2():
            var target_cell = cell + input_dir
            set_direction(_input_dir_to_dir(input_dir))
            try_move_to(target_cell)
        elif Input.is_action_just_released("ui_accept"):
            var target_cell = cell + Vector2(1, 0).rotated(get_direction() * PI / 2)
            var target_entity = get_room().get_entity_cell(target_cell)
            if target_entity != null:
                target_entity.on_interact()