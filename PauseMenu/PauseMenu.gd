extends Node2D

func is_active() -> bool:
    return visible

func unpause() -> void:
    visible = false
    get_tree().paused = false

func pause() -> void:
    visible = true
    get_tree().paused = true

func get_room():
    return get_parent().get_parent()

func _process(_delta: float) -> void:
    if is_active():

        # Allow unpausing (DEBUG CODE as this will be somewhere else later)
        if Input.is_action_just_released("ui_cancel") or Input.is_action_just_released("ui_pause"):
            unpause()

    else:
        if Input.is_action_just_released("ui_pause") and not get_room().is_showing_modal():
            pause()