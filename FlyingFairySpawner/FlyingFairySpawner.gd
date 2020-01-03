extends Node2D

const SPAWN_DISTANCE: float = 512.0

var FlyingFairy = load("res://FlyingFairy/FlyingFairy.tscn") # load() to break a cyclic reference :(

var fairy = null
var entity = null

func set_entity(entity):
    self.entity = entity

func get_room():
    return entity.get_room()

func activate() -> void:
    $StartDelayTimer.start(3 * randf())

func deactivate() -> void:
    $CycleTimer.stop()
    $StartDelayTimer.stop()

func _on_CycleTimer_timeout():
    var player_distance = EnemyAI.distance_to_player(entity)

    if get_room().is_showing_modal():
        # Don't spawn if in dialogue mode
        return
    if fairy != null:
        # Only allow one entity in play at a time
        return
    if $CooldownTimer.time_left > 0:
        # Cooling down after last fairy
        return
    if player_distance < SPAWN_DISTANCE:
        # Distance constraints are not satisfied
        return
    if randf() < 0.25:
        # Random chance of failure
        return

    fairy = FlyingFairy.instance()
    get_room().get_node("Entities").add_child(fairy)
    fairy.position = entity.position + Vector2(16, 16)
    fairy.connect("tree_exited", self, "_on_FlyingFairy_tree_exited")

func _on_StartDelayTimer_timeout():
    $CycleTimer.start()

func _on_FlyingFairy_tree_exited():
    fairy = null
    $CooldownTimer.start()

