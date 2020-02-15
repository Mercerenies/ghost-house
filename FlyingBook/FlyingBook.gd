extends FloatingEntity

const Player = preload("res://Player/Player.gd")

const VALID_COLORS = [Color(0xBA7153FF), Color(0x815D83FF), Color(0x945454FF), Color(0x565794FF), Color(0x57816AFF)]
const INTRO_IMAGE_SPEED = 8
const IMAGE_SPEED = 8
const CHARGING_IMAGE_SPEED = 16

const DISAPPEAR_SPEED = 2
const IDLE_MOVEMENT_SPEED = 10
const CHARGING_MOVEMENT_SPEED = 210
const FLEEING_MOVEMENT_SPEED = 180
const MAX_PLAYER_DISTANCE = 768
const MIN_CHARGE_DISTANCE = 128
const MAX_CHARGE_DISTANCE = 256
const FLEE_DISTANCE = 192

enum State {
    # Playing introductory animation
    Introducing,
    # Quietly following player
    Idle,
    # Charging for attack
    Preparing,
    # Attacking
    Attacking,
    # Running away from the player's light
    Fleeing,
    # Fading out
    Disappearing,
}

var state: int = State.Introducing
var attack_vector = Vector2()
var anim_index = 0.0
var hover_index = 0.0
var target_position: Vector2

func _ready() -> void:
    modulate = VALID_COLORS[randi() % len(VALID_COLORS)]

func _process(delta: float) -> void:
    if get_room().is_showing_modal():
        return

    match state:
        State.Introducing:
            anim_index += INTRO_IMAGE_SPEED * delta
            if anim_index >= 4:
                state = State.Idle

        State.Idle:
            hover_index += delta
            anim_index += IMAGE_SPEED * delta
            anim_index = (fmod((anim_index - 4), 4)) + 4
            $Sprite.position.y = 10 + 4 * sin(hover_index * 2 * PI)

            var player = EnemyAI.get_player(self)
            var player_dist = EnemyAI.distance_to_player(self)
            var player_dir = EnemyAI.player_line_of_sight(self)

            if player_dist > MAX_PLAYER_DISTANCE:
                state = State.Disappearing
            elif player_dir < 3 * PI / 8 and player_dist < FLEE_DISTANCE:
                var diff = global_position - player.global_position
                target_position = player.position + diff * 2
                state = State.Fleeing
            else:
                position += (player.global_position - global_position).normalized() * IDLE_MOVEMENT_SPEED * delta

        State.Preparing:
            hover_index += 2 * delta
            anim_index += CHARGING_IMAGE_SPEED * delta
            anim_index = (fmod((anim_index - 4), 4)) + 4
            $Sprite.position.y = 10 + 4 * sin(hover_index * 2 * PI)

            var player = EnemyAI.get_player(self)
            var player_dist = EnemyAI.distance_to_player(self)
            var player_dir = EnemyAI.player_line_of_sight(self)

            if player_dir < 3 * PI / 8 and player_dist < FLEE_DISTANCE:
                var diff = global_position - player.global_position
                target_position = player.position + diff * 2
                state = State.Fleeing

        State.Attacking:
            hover_index += 2 * delta
            anim_index += CHARGING_IMAGE_SPEED * delta
            anim_index = (fmod((anim_index - 4), 4)) + 4
            $Sprite.position.y = 10 + 4 * sin(hover_index * 2 * PI)
            position += attack_vector * CHARGING_MOVEMENT_SPEED * delta

        State.Fleeing:
            hover_index += 2 * delta
            anim_index += CHARGING_IMAGE_SPEED * delta
            anim_index = (fmod((anim_index - 4), 4)) + 4
            $Sprite.position.y = 10 + 4 * sin(hover_index * 2 * PI)

            position += (target_position - position).normalized() * FLEEING_MOVEMENT_SPEED * delta
            if (target_position - position).length() <= FLEEING_MOVEMENT_SPEED * delta:
                state = State.Idle

        State.Disappearing:
            hover_index += delta
            anim_index += IMAGE_SPEED * delta
            anim_index = (fmod((anim_index - 4), 4)) + 4
            $Sprite.position.y = 10 + 4 * sin(hover_index * 2 * PI)

            # If the attack vector is zero, this does nothing. If it's
            # nonzero, then continue the "attack" (for the sake of fluid
            # animation)
            position += attack_vector * CHARGING_MOVEMENT_SPEED * delta

            modulate.a = Util.toward(modulate.a, delta * DISAPPEAR_SPEED, 0)
            if modulate.a == 0:
                queue_free()

    $Sprite.frame = floor(anim_index)


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
        State.Introducing:
            pass
        State.Idle:
            var dist = EnemyAI.distance_to_player(self)
            var dir = EnemyAI.player_line_of_sight(self)
            if dist >= MIN_CHARGE_DISTANCE and dist < MAX_CHARGE_DISTANCE and dir > 3 * PI / 8:
                if randf() < 0.75:
                    state = State.Preparing
                    $StateTimer.start(randf() + 1)
        State.Preparing:
            var player = EnemyAI.get_player(self)
            var dir = EnemyAI.player_line_of_sight(self)
            if dir > 3 * PI / 8:
                attack_vector = (player.position + Vector2(16, 16) - self.position).normalized()
                state = State.Attacking
                $StateTimer.start(1.5)
        State.Attacking:
            state = State.Disappearing
            $StateTimer.stop()
        State.Disappearing:
            pass
