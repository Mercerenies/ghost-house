extends Entity

const Player = preload("res://Player/Player.gd")

const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

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

var state: int = State.Unplaced
var hideout_position: Vector2 = Vector2()

func _ready() -> void:
    _configure_image()
    _reset_position()

func _configure_image() -> void:
    var player = EnemyAI.get_player()
    if player != null:
        $Sprite.texture = player.get_node("Sprite").texture

func _reset_position() -> void:
    # Move out of bounds to avoid being involved in collisions, etc.
    position = Vector2(-1024, -1024)

func _process(delta: float) -> void:
    match state:
        State.Unplaced:
            pass
        State.Planted:
            pass
        State.Triggered:
            pass
        State.Stalking:
            pass
        State.Disappearing:
            pass

func _on_StateTimer_timeout():
    match state:
        State.Unplaced:
            pass
        State.Planted:
            pass
        State.Triggered:
            pass
        State.Stalking:
            pass
        State.Disappearing:
            pass

func _on_Area2D_area_entered(area):
    if state == State.Stalking:
        if area.get_parent() is Player:
            var stats = get_room().get_player_stats()
            if stats.damage_player(1):
                state = State.Disappearing
