extends Node2D

var MalePlayer = preload("res://Player/MalePlayer.png")

var _sprite_image_index = 0

func get_pause_menu():
    return get_parent()

func get_room():
    return get_pause_menu().get_room()

func _update_self() -> void:
    var player = get_room().get_marked_entities()["player"]
    var player_stats = get_room().get_player_stats()

    if player == null:
        $Sprite.texture = MalePlayer # Just a default in case we can't find the player
    else:
        $Sprite.texture = player.get_node("Sprite").texture

    $PlayerHealth.set_health(player_stats.get_player_health())
    $PlayerStamina.set_stamina(player_stats.get_player_stamina())
    $PlayerStamina.jump_to_value()
    $PlayerStamina.set_color_based_on_rate_multiplier(player_stats.get_status_effects().stamina_recovery_rate_multiplier())

    var desc_text = ""
    # Handle Statuses
    var status_effects = player_stats.get_status_effects().get_effect_list()
    desc_text += "Status: "
    if len(status_effects) == 0:
        desc_text += "Healthy"
    else:
        desc_text += status_effects[0].to_display_string()
        for i in range(1, len(status_effects)):
            desc_text += ", " + status_effects[i].to_display_string()
    desc_text += "\n"
    $PlayerDescription.set_text(desc_text)

func on_push() -> void:
    visible = true
    _update_self()
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
