extends Entity

const Player = preload("res://Player/Player.gd")
const Furniture = preload("res://Furniture/Furniture.gd")

enum State {
    Stalking,
    Migrating,
    Retreating,
    Hiding,
    Disappearing
}

#const HUE_CHANGE_SPEED = 0.05
const TOP_SPEED = 35.0
const ACCELERATION = 2.0
const TARGET_RADIUS = 6
const RETREAT_SPEED = 200.0
const MIGRATE_SPEED = 15.0
const BEGIN_STALK_DISTANCE = 256
const MAX_STALK_DISTANCE = 512
const DISAPPEAR_SPEED = 2

var state: int = State.Stalking
var light_radius: float = 32
#var hue: float = 0.0
var speed: float = 0.0
var target_position: Vector2 = Vector2()

# TODO Different dialogue if you inspect the furniture cell that the fairy happens to be on perhaps?

func _ready() -> void:
    #modulate = Color.from_hsv(hue, 1, 1)
    camouflage_self()

func _process(delta: float) -> void:
    if get_room().is_showing_modal():
        return

    match state:
        State.Stalking:
            var player = EnemyAI.get_player(self)
            var player_dir = EnemyAI.player_line_of_sight(self)
            var player_dist = EnemyAI.distance_to_player(self)
            var direction_vector = (player.global_position + Vector2(16, 16) - global_position).normalized()

            if player_dir < PI / 2 and player_dist > 32:
                state = State.Retreating
                speed = 0
                choose_retreat_target()
            else:
                position += direction_vector * speed * delta
                speed += ACCELERATION * delta
                speed = clamp(speed, 0, TOP_SPEED)
        State.Migrating:
            # Migration is really just a slower retreat. It can become a retreat
            # (to the same target cell) if the player sees the fairy moving.
            var direction_vector = (target_position - global_position).normalized()
            if (target_position - global_position).length() < MIGRATE_SPEED * delta:
                global_position = target_position
                state = State.Hiding
                camouflage_self()
            else:
                var player_dir = EnemyAI.player_line_of_sight(self)
                if player_dir < PI / 2:
                    state = State.Retreating
                else:
                    position += direction_vector * MIGRATE_SPEED * delta
        State.Retreating:
            var direction_vector = (target_position - global_position).normalized()
            if (target_position - global_position).length() < RETREAT_SPEED * delta:
                global_position = target_position
                state = State.Hiding
                camouflage_self()
            else:
                position += direction_vector * RETREAT_SPEED * delta
        State.Hiding:
            pass
        State.Disappearing:
            modulate.a = Util.toward(modulate.a, delta * DISAPPEAR_SPEED, 0)
            if modulate.a == 0:
                queue_free()

    #hue = fmod(hue + HUE_CHANGE_SPEED * delta, 1)
    #modulate = Color.from_hsv(hue, 1, 1, modulate.a)

# The difference between the following two functions is simple. choose_retreat_target()
# implies that the fairy is panicking and running away, hence it will always choose the
# nearest valid target (choosing randomly between equidistant targets). choose_migrate_target()
# is a more tactical movement, so the choice of destination will be uniformly distributed over
# all valid targets within TARGET_RADIUS cells.

func choose_retreat_target() -> void:
    var room = get_room()
    var occupied_cell = Vector2(floor(position.x / 32), floor(position.y / 32))
    var target_cell = occupied_cell * 32 + Vector2(16, 16)
    # In the unlikely event that we find no acceptable furniture nearby, enter "panic
    # mode" and just use the current cell.
    for r in range(TARGET_RADIUS + 1):
        var possible_cells = PoolVector2Array()
        for x in range(-r, r + 1):
            for y in [-r + abs(x), r - abs(x)]:
                var cell = occupied_cell + Vector2(x, y)
                var entity = room.get_entity_cell(cell)
                # Don't hide on empty cells
                if entity == null:
                    continue
                # Only hide on furniture
                if not (entity is Furniture):
                    continue
                # Don't hide on any furniture which already has its own light
                if entity.naturally_emits_light():
                    continue
                possible_cells.push_back(cell)
        if len(possible_cells) != 0:
            target_cell = Util.choose(possible_cells) * 32 + Vector2(16, 16)
            break
    target_position = target_cell

func choose_migrate_target():
    var room = get_room()
    var occupied_cell = Vector2(floor(position.x / 32), floor(position.y / 32))
    var target_cell = occupied_cell * 32 + Vector2(16, 16)
    # In the unlikely event that we find no acceptable furniture nearby, enter "panic
    # mode" and just use the current cell.
    var possible_cells = PoolVector2Array()
    for x in range(-TARGET_RADIUS, TARGET_RADIUS + 1):
        for y in range(-TARGET_RADIUS + abs(x), TARGET_RADIUS - abs(x) + 1):
            var cell = occupied_cell + Vector2(x, y)
            var entity = room.get_entity_cell(cell)
            # Don't hide on empty cells
            if entity == null:
                continue
            # Only hide on furniture
            if not (entity is Furniture):
                continue
            # Don't hide on any furniture which already has its own light
            if entity.naturally_emits_light():
                continue
            possible_cells.push_back(cell)
    if len(possible_cells) != 0:
        target_cell = Util.choose(possible_cells) * 32 + Vector2(16, 16)
    target_position = target_cell

func _on_Area2D_area_entered(area):
    if state != State.Hiding:
        if area.get_parent() is Player:
            var stats = get_room().get_player_stats()
            if stats.damage_player(1):
                state = State.Disappearing

func _on_StateTimer_timeout():
    if get_room().is_showing_modal():
        return
    var player_distance = EnemyAI.distance_to_player(self)
    match state:
        State.Stalking:
            if player_distance > MAX_STALK_DISTANCE:
                speed = 0
                state = State.Migrating
                choose_migrate_target()
        State.Migrating:
            pass
        State.Retreating:
            pass
        State.Hiding:
            var player_dir = EnemyAI.player_line_of_sight(self)
            if player_distance < BEGIN_STALK_DISTANCE and player_dir > PI / 2 and randf() < 0.9:
                state = State.Stalking
        State.Disappearing:
            pass

func get_light_radius() -> float:
    return light_radius

func set_light_radius(rad: float) -> void:
    light_radius = rad

func lighting() -> Array:
    return [{
        "type": "circle",
        "position": position,
        "radius": light_radius,
        "color": Color(1, 1, 1, modulate.a)
    }]

func naturally_emits_light() -> bool:
    return true

func camouflage_self() -> void:
    var occupied_cell = Vector2(floor(position.x / 32), floor(position.y / 32))
    var furniture = get_room().get_entity_cell(occupied_cell)
    if furniture != null and furniture is Furniture:
        var color = AverageColors.get_color(furniture)
        color.a = modulate.a
        modulate = color
