extends Node2D

# NOTE: For now, this should ONLY be used on 1x1 objects. We can make it work on bigger
# ones, but it would require some work.

const FlyingFurniture = preload("res://FlyingFurniture/FlyingFurniture.tscn")

const RESPAWN_DISTANCE: float = 512.0

export var minimum_distance: float = 64
export var maximum_distance: float = 256

var projectile = null
var entity = null
var sprite = null
var fade_in = false
var active = false

func _ready() -> void:
    if active:
        $StartDelayTimer.start(3 * randf())

func _process(delta: float) -> void:
    if fade_in:
        sprite.modulate.a = Util.toward(sprite.modulate.a, delta, 1)
        if sprite.modulate.a == 1:
            fade_in = false

func set_entity(entity):
    self.entity = entity

func set_sprite(sprite):
    self.sprite = sprite

func get_room():
    return entity.get_room()

func activate() -> void:
    active = true
    if is_inside_tree():
        $StartDelayTimer.start(3 * randf())

func deactivate() -> void:
    active = false
    if is_inside_tree():
        $CycleTimer.stop()
        $StartDelayTimer.stop()

func _on_CycleTimer_timeout():
    var player_distance = EnemyAI.distance_to_player(entity)
    var player_dir = EnemyAI.player_line_of_sight(entity)

    if get_room().is_showing_modal():
        # Don't spawn if in dialogue mode
        return
    if projectile != null:
        # Only allow one entity in play at a time
        return
    if $CooldownTimer.time_left > 0:
        # Cooling down after last launch
        return
    if player_distance < minimum_distance or player_distance >= maximum_distance:
        # Distance constraints are not satisfied
        return
    if player_dir < PI * 0.45:
        # The player is looking in this direction
        return
    if randf() < 0.25:
        # Random chance of failure
        return

    projectile = FlyingFurniture.instance()
    get_room().get_node("Entities").add_child(projectile)
    projectile.position = entity.position + Vector2(16, 16)
    projectile.set_sprite(sprite.duplicate(0))
    sprite.hide()
    projectile.connect("tree_exited", self, "_on_FlyingFurniture_tree_exited")

    entity.unposition_self()

func _on_StartDelayTimer_timeout():
    $CycleTimer.start()

func _on_FlyingFurniture_tree_exited():
    projectile = null
    if is_inside_tree():
        $CooldownTimer.start()

func _on_CooldownTimer_timeout():
    var room = get_room()
    if EnemyAI.distance_to_player(entity) > RESPAWN_DISTANCE and room.get_entity_cell(entity.cell) == null:
        sprite.show()
        sprite.modulate.a = 0
        fade_in = true
        entity.position_self()
    else:
        $CooldownTimer.start()
