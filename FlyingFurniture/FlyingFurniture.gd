extends Entity

const Player = preload("res://Player/Player.gd")

const INTRO_HOVER_SPEED = 32
const LAUNCH_SPEED = 210
const LAUNCH_ANGULAR_SPEED = 2 * PI
const DISAPPEAR_SPEED = 2

enum State {
    Introducing,
    Stalling,
    Launching,
    Disappearing,
}

var sprite = null
var state: int = State.Introducing
var attack_vector = Vector2()
var attack_angle = 0

func _ready() -> void:
    $StateTimer.start(1)

func _process(delta: float) -> void:
    match state:
        State.Introducing:
            position.y -= INTRO_HOVER_SPEED * delta
        State.Stalling:
            pass
        State.Launching:
            position += attack_vector * LAUNCH_SPEED * delta
            sprite.rotation += attack_angle * LAUNCH_ANGULAR_SPEED * delta
        State.Disappearing:
            position += attack_vector * LAUNCH_SPEED * delta
            sprite.rotation += attack_angle * LAUNCH_ANGULAR_SPEED * delta

            # If the attack vector is zero, this does nothing. If it's
            # nonzero, then continue the "attack" (for the sake of fluid
            # animation)
            modulate.a = Util.toward(modulate.a, delta * DISAPPEAR_SPEED, 0)
            if modulate.a == 0:
                queue_free()

func set_sprite(sprite) -> void:
    if self.sprite != null:
        self.sprite.queue_free()
    self.sprite = sprite
    self.add_child(self.sprite)
    self.sprite.position -= Vector2(16, 16)

func _on_Area2D_area_entered(area):
    if state != State.Disappearing:
        if area.get_parent() is Player:
            var stats = get_room().get_player_stats()
            if stats.damage_player(1):
                state = State.Disappearing

func _on_StateTimer_timeout():
    match state:
        State.Introducing:
            state = State.Stalling
            $StateTimer.start(randf() * 2 + 1)
        State.Stalling:
            var player = EnemyAI.get_player(self)
            var dir = EnemyAI.player_line_of_sight(self)
            if dir > 3 * PI / 8:
                attack_vector = (player.position + Vector2(16, 16) - self.position).normalized()
                attack_angle = sign(attack_vector.x)
                if attack_angle == 0:
                    attack_angle = 1
                state = State.Launching
                $StateTimer.start(1.5)
            else:
                $StateTimer.start(2)
            
        State.Launching:
            state = State.Disappearing
