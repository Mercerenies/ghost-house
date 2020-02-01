extends Node2D

var MalePlayer = preload("res://Player/MalePlayer.png")

var _sprite_image_index = 0

func get_pause_menu():
    return get_parent()

func get_room():
    return get_pause_menu().get_room()

func on_push() -> void:
    visible = true
    var player = get_room().get_marked_entities()["player"]
    if player == null:
        $Sprite.texture = MalePlayer # Just a default in case we can't find the player
    else:
        $Sprite.texture = player.get_node("Sprite").texture
    $SpriteAnimationTimer.start()

func on_pop() -> void:
    visible = false
    $SpriteAnimationTimer.stop()

func _ready() -> void:
    visible = false

func _process(_delta: float) -> void:
    $Sprite.frame = 4 + _sprite_image_index # 4 = 4 * FACING_DOWNWARD

func handle_input(input_type: String) -> bool:
    match input_type:
        "ui_down", "ui_up", "ui_accept":
            pass
        "ui_cancel":
            get_pause_menu().pop_control()
    return true # Modal

func _on_SpriteAnimationTimer_timeout():
    _sprite_image_index = (_sprite_image_index + 1) % 4
