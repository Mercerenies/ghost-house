extends Node2D

const FlyingBook = preload("res://FlyingBook/FlyingBook.tscn")

export var width: float = 16
export var height: float = 16

export var minimum_distance: float = 64
export var maximum_distance: float = 256

var book = null
var entity = null
var active = false

func _ready() -> void:
    if active:
        $StartDelayTimer.start(3 * randf())

func set_entity(entity):
    self.entity = entity

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
    if book != null:
        # Only allow one book in play at a time
        return
    if $CooldownTimer.time_left > 0:
        # Cooling down after last book
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

    book = FlyingBook.instance()
    get_room().get_node("Entities").add_child(book)
    book.position = self.global_position + Vector2(randf() * width, randf() * height)
    book.connect("tree_exited", self, "_on_FlyingBook_tree_exited")

func _on_StartDelayTimer_timeout():
    $CycleTimer.start()

func _on_FlyingBook_tree_exited():
    book = null
    if is_inside_tree():
        $CooldownTimer.start()
