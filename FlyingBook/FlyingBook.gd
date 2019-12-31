extends Entity

const Player = preload("res://Player/Player.gd")

const VALID_COLORS = [Color(0xBA7153FF), Color(0x815D83FF), Color(0x945454FF), Color(0x565794FF), Color(0x57816AFF)]
const INTRO_IMAGE_SPEED = 8
const IMAGE_SPEED = 8
const DISAPPEAR_SPEED = 2

var introducing = true
var disappearing = false
var anim_index = 0.0
var hover_index = 0.0

func _ready() -> void:
    modulate = VALID_COLORS[randi() % len(VALID_COLORS)]

func _process(delta: float) -> void:
    if get_room().is_showing_modal():
        return

    if introducing:
        anim_index += INTRO_IMAGE_SPEED * delta
        if anim_index >= 4:
            introducing = false
    else:
        hover_index += delta
        anim_index += IMAGE_SPEED * delta
        anim_index = (fmod((anim_index - 4), 4)) + 4
        $Sprite.position.y = 10 + 4 * sin(hover_index * 2 * PI)

    if disappearing:
        modulate.a = Util.toward(modulate.a, delta * DISAPPEAR_SPEED, 0)
        if modulate.a == 0:
            queue_free()

    $Sprite.frame = floor(anim_index)


func _on_Area2D_area_entered(area):
    if not (introducing or disappearing):
        if area.get_parent() is Player:
            var stats = get_room().get_player_stats()
            if stats.damage_player(1):
                disappearing = true
