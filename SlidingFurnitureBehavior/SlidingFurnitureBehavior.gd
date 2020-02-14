extends Node2D

const MIN_TRIGGER_DISTANCE = 64
const MAX_TRIGGER_DISTANCE = 256

const ROW_TOLERANCE = 2

var movement: Vector2 = Vector2()

func get_furniture() -> StaticEntity:
    return get_parent() as StaticEntity

func get_room():
    return get_furniture().get_room()

func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

func activate() -> void:
    var player = EnemyAI.get_player(self)
    if player != null and not player.is_connected("player_moved", self, "_on_Player_player_moved"):
        player.connect("player_moved", self, "_on_Player_player_moved")

func deactivate() -> void:
    var player = EnemyAI.get_player(self)
    if player != null and player.is_connected("player_moved", self, "_on_Player_player_moved"):
        player.disconnect("player_moved", self, "_on_Player_player_moved")

func _consider_triggering() -> void:
    var furniture = get_furniture()
    var room = get_room()
    var player = EnemyAI.get_player(furniture)
    var dist = EnemyAI.distance_to_player(furniture)

    if player != null and dist >= MIN_TRIGGER_DISTANCE and dist < MAX_TRIGGER_DISTANCE:
        var diffx = player.global_position.x - furniture.global_position.x
        var diffy = player.global_position.y - furniture.global_position.y
        if min(abs(diffx), abs(diffy)) <= ROW_TOLERANCE:
            var direction
            if abs(diffx) > abs(diffy):
                direction = Vector2(sign(diffx), 0)
            else:
                direction = Vector2(0, sign(diffy))
            var test_index = 32
            while test_index < max(abs(diffx), abs(diffy)):
                var test_pos = furniture.global_position + direction * test_index
                test_pos = Vector2(round(test_pos.x / 32), round(test_pos.y / 32))
                if room.is_wall_at(test_pos):
                    # There's something in the way of us hitting the
                    # player successfully, so don't move.
                    return
                test_index += 32
            movement = direction
            furniture.unposition_self()

func _on_Player_player_moved(_speed: float) -> void:
    if get_furniture().is_positioned() and $CooldownTimer.time_left <= 0:
        _consider_triggering()

func _on_CooldownTimer_timeout():
    if get_furniture().is_positioned():
        _consider_triggering()
