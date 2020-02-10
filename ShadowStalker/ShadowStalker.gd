extends Entity

const Player = preload("res://Player/Player.gd")

const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

const APPEAR_AFTER_LOGS = 16
const DISAPPEAR_AFTER_LOGS = 128
const APPEAR_SPEED = 2
const DISAPPEAR_SPEED = 2
const IMAGE_SPEED = 10

enum State {
    # Hiding out, inactive
    Unplaced,
    # Planted in a transition space, in hiding
    Planted,
    # Triggered, watching the player's movements
    Triggered,
    # Stalking the player, still watching future movements
    Stalking,
    # Disappearing
    Disappearing,
}

# State, determines overarching behavior at the moment
var state: int = State.Unplaced
# Used in State.Planted; when the player steps inside this box, we
# move to State.Triggered.
var hideout_box: Rect2 = Rect2()
# The tick, managed by $TickTimer, used to determine the "time" in the
# movement_log.
var tick: int = 0
# The moment we switched from State.Triggered to State.Stalking, using
# the same units as `tick' above.
var tick_delay: int = 0
# The log. Each entry is of the form { "position": position, "speed":
# speed, "time": tick }.
var movement_log: Array = []
# The current index in the log.
var log_index: int = 0
# Current target position when actively stalking
var target_pos: Vector2 = Vector2()
# Current movement speed when stalking
var target_speed: float = 0.0
# Animation index, for the visuals
var anim_index: float = 0.0

func _ready() -> void:
    _configure_self()
    _reset_position()

# Sets up signals and appearance to link with the player.
func _configure_self() -> void:
    var player = EnemyAI.get_player(self)
    if player != null:
        $Sprite.texture = player.get_node("Sprite").texture
        if not player.is_connected("player_moved", self, "_on_Player_player_moved"):
            player.connect("player_moved", self, "_on_Player_player_moved")

func _reset_position() -> void:
    # Move out of bounds to avoid being involved in collisions, etc.
    position = Vector2(-1024, -1024)
    modulate.a = 0
    $TickTimer.stop()
    target_pos = Vector2()
    target_speed = 0.0

func _try_to_place_self() -> void:
    var minimap = get_room().get_minimap()
    var connections = minimap.get_connections_list()

    var attempt = Util.choose(connections)
    # There may be some more specific criteria later, but for now, any
    # connection will do.
    var rect = RoomDimensions.connection_rect(attempt)
    hideout_box = rect
    state = State.Planted
    _configure_self()
    print(hideout_box.position / 6) # DEBUG CODE

func _process(delta: float) -> void:
    if get_room().is_showing_modal():
        return

    var prior_pos = position
    match state:
        State.Stalking:
            modulate.a = Util.toward(modulate.a, delta * APPEAR_SPEED, 1)
            anim_index = fmod(anim_index + IMAGE_SPEED * delta, 4.0)

            if log_index >= len(movement_log):
                state = State.Disappearing
            else:
                var tick_with_delay = tick - tick_delay
                var current = movement_log[log_index]
                if tick_with_delay > current['time']:
                    log_index += 1
                else:
                    target_speed = current['speed']
                    target_pos = current['position'] * 32
                    if (target_pos - position).length() < target_speed * delta:
                        position = target_pos
                    else:
                        position += (target_pos - position).normalized() * target_speed * delta

        State.Disappearing:
            if (target_pos - position).length() < target_speed * delta:
                position = target_pos
            else:
                position += (target_pos - position).normalized() * target_speed * delta

            anim_index = fmod(anim_index + IMAGE_SPEED * delta, 4.0)

            modulate.a = Util.toward(modulate.a, delta * DISAPPEAR_SPEED, 0)
            if modulate.a == 0:
                state = State.Unplaced
                _reset_position()

    if prior_pos == position:
        $Sprite.frame = floor($Sprite.frame / 4) * 4
    else:
        var dir = (position - prior_pos).angle()
        dir = int(round(dir / (PI / 2))) % 4
        $Sprite.frame = int(dir * 4 + anim_index)

func _on_StateTimer_timeout():
    if get_room().is_showing_modal():
        return

    if state == State.Unplaced:
        _try_to_place_self()

func _on_Area2D_area_entered(area):
    if state == State.Stalking:
        if area.get_parent() is Player:
            var stats = get_room().get_player_stats()
            if stats.damage_player(1):
                state = State.Disappearing

func _on_Player_player_moved(speed: float) -> void:
    match state:

        State.Planted:
            var player = EnemyAI.get_player(self)
            var player_cell = player.cell
            if hideout_box.has_point(player_cell):
                state = State.Triggered
                tick = 0
                movement_log = []
                $TickTimer.start()
                movement_log.append({ "position": player_cell, "speed": 100, "time": 0 })
                print("Triggered") # DEBUG CODE

        State.Triggered, State.Stalking:
            var player = EnemyAI.get_player(self)
            var player_cell = player.cell
            movement_log.append({ "position": player_cell, "speed": speed, "time": tick })
            if state == State.Triggered and len(movement_log) >= APPEAR_AFTER_LOGS:
                state = State.Stalking
                position = movement_log[0]['position'] * 32
                tick_delay = tick
                log_index = 0
                print("Stalking") # DEBUG CODE
            if state == State.Stalking and len(movement_log) >= DISAPPEAR_AFTER_LOGS:
                state = State.Disappearing

func _on_TickTimer_timeout():
    if get_room().is_showing_modal():
        return

    if state in [State.Triggered, State.Stalking]:
        tick += 1
