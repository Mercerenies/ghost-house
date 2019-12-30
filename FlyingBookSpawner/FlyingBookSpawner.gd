class_name FlyingBookSpawner
extends Node2D

const FlyingBook = preload("res://FlyingBook/FlyingBook.tscn")

export var width: float = 16
export var height: float = 16

export var minimum_distance: float = 64
export var maximum_distance: float = 256

var book = null
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
    var player = get_room().get_marked_entities()['player']
    var player_distance = (player.global_position - global_position).length()
    var player_dir = abs((position - player.position).angle_to(Vector2(1, 0).rotated(player.get_direction() * PI / 2.0)))

    if book != null:
        # Only allow one book in play at a time
        return
    if player_distance < minimum_distance or player_distance >= maximum_distance:
        # Distance constraints are not satisfied
        return
    if player_dir < PI * 0.45:
        # The player is looking in this direction
        return
    if randf() < 0.5:
        # Random chance of failure
        return

    book = FlyingBook.instance()
    get_room().get_node("Entities").add_child(book)
    book.position = self.global_position + Vector2(randf() * width, randf() * height)

func _on_StartDelayTimer_timeout():
    $CycleTimer.start()
