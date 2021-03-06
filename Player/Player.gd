extends MobileEntity

signal player_moved(speed)

const OutlineMaterial = preload("Outline.tres")
const PlayerLight = preload("res://Lighting/PlayerLight.tscn")

var _lighting = null

var base_speed: float
var stamina_recovery_rate: float = 10
var stamina_dash_cost: float = 5

func _ready():
    base_speed = speed
    $Sprite.visible = false
    set_direction(get_direction()) # Normalize and make the flashlight
                                   # face the right way.

func set_direction(a: int) -> void:
    if _lighting != null and _lighting.is_inside_tree():
        _lighting.set_direction(a)
    .set_direction(a)

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

func _process_movement(delta: float) -> void:
    if _can_move_at_all():
        var stats = get_room().get_player_stats()
        var effects = stats.get_status_effects()
        var input_dir = get_input_direction()
        var is_running = false

        if input_dir != Vector2():
            var target_cell = cell + input_dir
            set_direction(_input_dir_to_dir(input_dir))
            speed = base_speed
            if Input.is_action_pressed("ui_dash") and stats.get_player_stamina() >= stamina_dash_cost:
                if effects.can_dash():
                    speed *= 2
                    is_running = true
            if try_move_to(target_cell):
                emit_signal("player_moved", speed)
                if is_running:
                    stats.add_player_stamina(- stamina_dash_cost)

    ._process_movement(delta)

func _process(delta: float) -> void:

    var stats = get_room().get_player_stats()
    var effects = stats.get_status_effects()
    if _can_move_at_all():
        if Input.is_action_just_released("ui_accept"):
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
        var recovery_rate = stamina_recovery_rate * effects.stamina_recovery_rate_multiplier()
        stats.add_player_stamina(recovery_rate * delta)
    if stats.has_iframe():
        get_sprite().modulate.a = 0.5
    else:
        get_sprite().modulate.a = 1.0

func set_position(value: Vector2) -> void:
    if _lighting != null and _lighting.is_inside_tree():
        _lighting.position = value
        # Don't know why this is needed, but it fixes one-frame lag.
        # See: https://godotengine.org/qa/6197/how-to-stop-camera-lag
        _lighting.get_node("Camera2D").align()
    .set_position(value)

func get_view_bounds() -> Rect2:
    var viewport = get_viewport()
    var center = $Camera2D.global_position + $Camera2D.offset
    return Rect2(center - viewport.size / 2, viewport.size)

func naturally_emits_light() -> bool:
    return true

func flashlight_triangle() -> PoolVector2Array:
    var arr = PoolVector2Array()
    var base_point = get_position() + Vector2(16, 16) + Vector2(-16, 0).rotated(get_direction() * PI / 2.0)
    var range_ = Vector2(192, 0).rotated(get_direction() * PI / 2.0)
    var fov = PI * 0.45
    arr.append(base_point)
    arr.append(base_point + Vector2(range_.length(),   range_.length() * tan(fov / 2.0)).rotated(range_.angle()))
    arr.append(base_point + Vector2(range_.length(), - range_.length() * tan(fov / 2.0)).rotated(range_.angle()))
    return arr

func base_flashlight_radius() -> int:
    return 64

func _on_PlayerStatusEffects_status_effects_changed():
    var sprite = get_sprite()
    var effects = get_room().get_player_stats().get_status_effects()
    var is_invincible = (effects.player_damage_multiplier() == 0)
    if is_invincible:
        sprite.material = OutlineMaterial
    else:
        sprite.material = null

func _on_Player_tree_entered():
    var status_effects = get_room().get_player_stats().get_status_effects()
    _lighting = PlayerLight.instance()
    _lighting.position = get_position()
    var result = status_effects.connect("status_effects_changed", _lighting, "_on_PlayerStatusEffects_status_effects_changed")
    assert(result == OK)
    get_room().get_lighting().add_light(_lighting)

func _on_Player_tree_exiting():
    if _lighting != null and _lighting.is_inside_tree():
        _lighting.queue_free()
        _lighting = null
