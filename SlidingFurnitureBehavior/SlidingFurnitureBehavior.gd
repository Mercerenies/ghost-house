extends Node2D

# NOTE: Like with FlyingFurnitureSpawner, this currently assumes a 1x1
# object (both in this code and in the collision mask). We could
# change that, but it's not quite a trivial change to make.

const Player = preload("res://Player/Player.gd")

const OOB_CELL = Vector2(-2048, -2048)

const MIN_TRIGGER_DISTANCE = 64
const MAX_TRIGGER_DISTANCE = 256
const MAX_IN_PLAY_DISTANCE = 512

const ROW_TOLERANCE = 2

const ATTACK_SPEED = 240
const APPEAR_SPEED = 2
const DISAPPEAR_SPEED = 2

var movement: Vector2 = Vector2()
var owner_origin: Vector2 = Vector2()
var disappearing: bool = false
var respawning: bool = false

onready var GeneratorPlacementHelper = load("res://GeneratorPlacementHelper/GeneratorPlacementHelper.gd")

func get_furniture() -> StaticEntity:
    return get_parent() as StaticEntity

func get_room():
    return get_furniture().get_room()

func _ready() -> void:
    owner_origin = get_furniture().position
    $DisappearCheckTimer.start(randf() * 5)

func _process(delta: float) -> void:
    var furniture = get_furniture()

    if not furniture.is_positioned():
        furniture.position += movement * ATTACK_SPEED * delta
        # Test for position capture
        var target_cell = Vector2(round(furniture.position.x / 32), round(furniture.position.y / 32))
        var aligned = target_cell * 32
        if (aligned - furniture.position).length() <= ATTACK_SPEED * delta and not disappearing:
            # Movement is a normalized vector, so target_cell +
            # movement is the "next" position we would have to move
            # to. If it's occupied, then stop.
            var collision_cell = target_cell + movement
            if GeneratorPlacementHelper.is_blocked(get_room(), collision_cell):
                # Keep moving if it's the player.
                if not (get_room().get_entity_cell(collision_cell) is Player):
                    # Try to place self at target_cell. If we can't, then
                    # disappear. In the ideal case, we always can place
                    # ourselves, but it's possible a ghost or something
                    # moved onto this position at the same time as us, so
                    # we need to be prepared for the worst.
                    movement = Vector2()
                    furniture.position = aligned
                    if get_room().get_entity_cell(target_cell) == null:
                        get_room().set_entity_cell(target_cell, furniture)
                        furniture.cell = target_cell
                        $CooldownTimer.start()
                    else:
                        disappearing = true

    if disappearing:
        furniture.modulate.a = Util.toward(furniture.modulate.a, delta * DISAPPEAR_SPEED, 0)
        if furniture.modulate.a == 0:
            furniture.position = OOB_CELL
            movement = Vector2()
            disappearing = false

    if respawning:
        furniture.modulate.a = Util.toward(furniture.modulate.a, delta * DISAPPEAR_SPEED, 1)
        if furniture.modulate.a == 1:
            var target_cell = Vector2(round(furniture.position.x / 32), round(furniture.position.y / 32))
            if get_room().get_entity_cell(target_cell) == null:
                get_room().set_entity_cell(target_cell, furniture)
                furniture.cell = target_cell
                respawning = false

func activate() -> void:
    var player = EnemyAI.get_player(self)
    if player != null and not player.is_connected("player_moved", self, "_on_Player_player_moved"):
        player.connect("player_moved", self, "_on_Player_player_moved")

func deactivate() -> void:
    var player = EnemyAI.get_player(self)
    if player != null and player.is_connected("player_moved", self, "_on_Player_player_moved"):
        player.disconnect("player_moved", self, "_on_Player_player_moved")

func _consider_triggering() -> void:
    if respawning:
        return # Do nothing if respawning

    var furniture = get_furniture()
    var room = get_room()
    var player = EnemyAI.get_player(furniture)
    var dist = EnemyAI.distance_to_player(furniture)

    if player != null and dist >= MIN_TRIGGER_DISTANCE and dist < MAX_TRIGGER_DISTANCE:
        var diffx = player.global_position.x - furniture.global_position.x
        var diffy = player.global_position.y - furniture.global_position.y
        if min(abs(diffx), abs(diffy)) <= ROW_TOLERANCE * 32:
            var direction
            if abs(diffx) > abs(diffy):
                direction = Vector2(sign(diffx), 0)
            else:
                direction = Vector2(0, sign(diffy))
            var test_index = 32
            while test_index < max(abs(diffx), abs(diffy)):
                var test_pos = furniture.global_position + direction * test_index
                test_pos = Vector2(round(test_pos.x / 32), round(test_pos.y / 32))
                if GeneratorPlacementHelper.is_blocked(room, test_pos):
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

func _on_Area2D_area_entered(area):
    var cls = get_script()
    if area.get_parent() is Player:
        var stats = get_room().get_player_stats()
        if stats.damage_player(1):
            disappearing = true
            if get_furniture().is_positioned():
                get_furniture().unposition_self()
    elif area.get_parent() is cls:
        # Bounce off of other sliding furniture entities
        if not disappearing and not area.get_parent().disappearing:
            movement *= -1

func _on_DisappearCheckTimer_timeout():
    $DisappearCheckTimer.wait_time = 5
    var furniture = get_furniture()
    var player = EnemyAI.get_player(furniture)
    var dist = EnemyAI.distance_to_player(furniture)
    if furniture.position != owner_origin and furniture.position != OOB_CELL and dist > MAX_IN_PLAY_DISTANCE:
        disappearing = true
        if furniture.is_positioned():
            furniture.unposition_self()
    if furniture.position == OOB_CELL and (player.position - owner_origin).length() > MAX_IN_PLAY_DISTANCE:
        furniture.modulate.a = 0
        furniture.position = owner_origin
        respawning = true
