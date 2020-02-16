extends Node2D

const MalePlayer = preload("res://Player/MalePlayer.png")
const StatusBox = preload("res://PauseMenu/StatusBox/StatusBox.tscn")

const STATUS_AILMENTS_PANE_WIDTH = 452
const STATUS_AILMENTS_ITEM_WIDTH = 64
const STATUS_AILMENTS_ITEM_HEIGHT = 96

var _sprite_image_index = 0

func get_pause_menu():
    return get_parent()

func get_room():
    return get_pause_menu().get_room()

func _update_self() -> void:
    var player = get_room().get_marked_entities()[Mark.PLAYER]
    var player_stats = get_room().get_player_stats()

    if player == null:
        $Sprite.texture = MalePlayer # Just a default in case we can't find the player
    else:
        $Sprite.texture = player.get_node("Sprite").texture

    $PlayerHealth.set_health(player_stats.get_player_health())
    $PlayerStamina.set_stamina(player_stats.get_player_stamina())
    $PlayerStamina.jump_to_value()
    $PlayerStamina.set_color_based_on_rate_multiplier(player_stats.get_status_effects().stamina_recovery_rate_multiplier())

    # Handle Statuses
    var desc_text = ""
    var status_effects = player_stats.get_status_effects().get_effect_list()

    desc_text += "Status Effects: "
    if len(status_effects) == 0:
        desc_text += "(None)"
    $StatusAilmentsLabel.set_text(desc_text)

    for box in $StatusAilmentsList.get_children():
        box.queue_free()
    var xpos = 0
    var ypos = 0
    for eff in status_effects:
        var box = StatusBox.instance()
        box.set_status(eff)
        box.position = Vector2(xpos, ypos)
        $StatusAilmentsList.add_child(box)
        xpos += STATUS_AILMENTS_ITEM_WIDTH
        if xpos >= STATUS_AILMENTS_PANE_WIDTH - STATUS_AILMENTS_ITEM_WIDTH:
            xpos = 0
            ypos += STATUS_AILMENTS_ITEM_HEIGHT

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
