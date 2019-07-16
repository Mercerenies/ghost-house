extends MobileEntity

func _ready():
    pass

func get_input_direction() -> Vector2:
    var vec = Vector2(
        int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
        int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
    )
    if vec.x != 0:
        vec.y = 0
    return vec

func can_move_to(pos: Vector2) -> bool:
    if position != target_pos:
        return false
    if get_room().is_showing_modal():
        return false
    return .can_move_to(pos)

func _process(delta: float) -> void:
    var input_dir = get_input_direction()
    var target_cell = cell + input_dir
    if input_dir != Vector2():
        try_move_to(target_cell)
