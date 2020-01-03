extends MobileEntity

signal player_moved

var base_speed: float
var stamina_recovery_rate: float = 10
var stamina_dash_cost: float = 5

func _ready():
    base_speed = speed
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
    var stats = get_room().get_player_stats()
    var input_dir = get_input_direction()
    if _can_move_at_all():
        if input_dir != Vector2():
            var target_cell = cell + input_dir
            set_direction(_input_dir_to_dir(input_dir))
            speed = base_speed
            if Input.is_action_pressed("ui_dash") and stats.get_player_stamina() >= stamina_dash_cost:
                speed *= 2
                stats.add_player_stamina(- stamina_dash_cost)
            if try_move_to(target_cell):
                emit_signal("player_moved")
        elif Input.is_action_just_released("ui_accept"):
            var target_cell = cell + Vector2(1, 0).rotated(get_direction() * PI / 2)
            target_cell = Vector2(round(target_cell.x), round(target_cell.y))
            var target_entity = get_room().get_entity_cell(target_cell)
            if target_entity != null:
                target_entity.on_interact()
        elif Input.is_action_just_released("ui_debug_tap"):
            # DEBUG CODE
            var target_cell = cell + Vector2(1, 0).rotated(get_direction() * PI / 2)
            target_cell = Vector2(round(target_cell.x), round(target_cell.y))
            var target_entity = get_room().get_entity_cell(target_cell)
            if target_entity != null:
                target_entity.on_debug_tap()
    if not Input.is_action_pressed("ui_dash"):
        stats.add_player_stamina(stamina_recovery_rate * delta)
    if stats.has_iframe():
        modulate.a = 0.5
    else:
        modulate.a = 1.0

func lighting() -> Array:
    return [
        {
            "type": "circle",
            "position": position + Vector2(16, 16),
            "radius": 64,
            "color": Color(1, 1, 1, 1)
        },
        {
            "type": "flashlight",
            "position": position + Vector2(16, 16) + Vector2(-16, 0).rotated(get_direction() * PI / 2.0),
            "range": Vector2(192, 0).rotated(get_direction() * PI / 2.0),
            "fov": PI * 0.45,
            "color": Color(1, 1, 1, 1)
        }
    ]

func naturally_emits_light() -> bool:
    return true
