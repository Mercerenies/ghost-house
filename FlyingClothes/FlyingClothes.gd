extends Entity

const Player = preload("res://Player/Player.gd")

const APPEAR_SPEED = 2
const DISAPPEAR_SPEED = 2
const HIDEAWAY_SPEED = 10.0
const PANIC_HIDEAWAY_SPEED = 150.0
const CHARGING_MOVEMENT_SPEED = 200.0
const FLEE_DISTANCE = 512
const TARGET_DISTANCE = 256
const TARGET_RADIUS = 6

enum State {
    # Playing introductory animation
    Introducing,
    # Pursuing a hiding spot
    Retreating,
    # Running to a hiding spot
    Fleeing,
    # Hiding in wait
    Hiding,
    # Waiting to strike the player
    Waiting,
    # Striking the player
    Attacking,
    # Fading out
    Disappearing,
}

var state: int = State.Introducing
var target_position: Vector2
var attack_vector = Vector2()
var rotate_index = 0.0

func _ready() -> void:
    scale.x = 0
    $Sprite.frame = randi() % 3

func choose_flee_target():
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
            possible_cells.push_back(cell)
    if len(possible_cells) != 0:
        target_cell = Util.choose(possible_cells) * 32 + Vector2(16, 16)
    target_position = target_cell

func _process(delta: float) -> void:
    if get_room().is_showing_modal():
        return

    match state:
        State.Introducing:
            scale.x = Util.toward(scale.x, APPEAR_SPEED * delta, 1)
            if scale.x == 1:
                choose_flee_target()
                state = State.Retreating
        State.Retreating:
            var player_dir = EnemyAI.player_line_of_sight(self)
            var player_dist = EnemyAI.distance_to_player(self)
            var speed = HIDEAWAY_SPEED * delta
            var direction_vector = (target_position - global_position).normalized()
            if (target_position - global_position).length() < speed:
                global_position = target_position
                state = State.Hiding
            else:
                position += direction_vector * speed
            if player_dir < PI / 3 and player_dist < FLEE_DISTANCE:
                state = State.Fleeing
        State.Fleeing:
            var speed = PANIC_HIDEAWAY_SPEED * delta
            var direction_vector = (target_position - global_position).normalized()
            if (target_position - global_position).length() < speed:
                global_position = target_position
                state = State.Hiding
            else:
                position += direction_vector * speed
        State.Hiding:
            pass
        State.Waiting:
            pass
        State.Attacking:
            position += attack_vector * CHARGING_MOVEMENT_SPEED * delta
        State.Disappearing:
            # If the attack vector is zero, this does nothing. If it's
            # nonzero, then continue the "attack" (for the sake of fluid
            # animation)
            position += attack_vector * CHARGING_MOVEMENT_SPEED * delta

            modulate.a = Util.toward(modulate.a, delta * DISAPPEAR_SPEED, 0)
            if modulate.a == 0:
                queue_free()

    match state:
        State.Retreating:
            rotate_index += delta / 2
        State.Fleeing, State.Attacking:
            rotate_index += delta
        State.Disappearing:
            if attack_vector != Vector2():
                rotate_index += delta
            else:
                continue
        _:
            var target_index = ceil(rotate_index * 2) / 2
            rotate_index = Util.toward(rotate_index, delta / 2, target_index)
    rotation = (PI / 6) * sin(rotate_index * 2 * PI)

func _on_Area2D_area_entered(area):
    if state != State.Introducing and state != State.Disappearing:
        if area.get_parent() is Player:
            var stats = get_room().get_player_stats()
            if stats.damage_player(1):
                state = State.Disappearing

func _on_StateTimer_timeout():
    if get_room().is_showing_modal():
        return
    match state:
        State.Hiding:
            var player_dir = EnemyAI.player_line_of_sight(self)
            var player_dist = EnemyAI.distance_to_player(self)
            if player_dir < PI / 3 and player_dist < TARGET_DISTANCE:
                state = State.Waiting
        State.Waiting:
            var player = EnemyAI.get_player(self)
            var player_dir = EnemyAI.player_line_of_sight(self)
            var player_dist = EnemyAI.distance_to_player(self)
            if player_dir > PI / 2 and player_dist < TARGET_DISTANCE:
                attack_vector = (player.position + Vector2(16, 16) - self.position).normalized()
                state = State.Attacking
                $StateTimer.start(1.5)
        State.Attacking:
            state = State.Disappearing
            $StateTimer.stop()
