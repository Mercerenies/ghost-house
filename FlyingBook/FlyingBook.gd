extends Entity

const Player = preload("res://Player/Player.gd")

const VALID_COLORS = [Color(0xBA7153FF), Color(0x815D83FF), Color(0x945454FF), Color(0x565794FF), Color(0x57816AFF)]
const INTRO_IMAGE_SPEED = 8
const IMAGE_SPEED = 8
const DISAPPEAR_SPEED = 2
const IDLE_MOVEMENT_SPEED = 10

enum State {
    Introducing,
    Idle,
    Disappearing,
}

var state: int = State.Introducing
var anim_index = 0.0
var hover_index = 0.0

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
            var player = get_room().get_marked_entities()['player']
            position += (player.global_position - global_position).normalized() * IDLE_MOVEMENT_SPEED * delta
        State.Disappearing:
            modulate.a = Util.toward(modulate.a, delta * DISAPPEAR_SPEED, 0)
            if modulate.a == 0:
                queue_free()

    $Sprite.frame = floor(anim_index)


func _on_Area2D_area_entered(area):
    if state == State.Idle:
        if area.get_parent() is Player:
            var stats = get_room().get_player_stats()
            if stats.damage_player(1):
                state = State.Disappearing
                
