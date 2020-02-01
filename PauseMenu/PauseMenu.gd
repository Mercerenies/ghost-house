extends Node2D

const CONTROL_STACK_ACTIONS = ["ui_up", "ui_down", "ui_accept"]

var control_stack: Array = [] # Right-hand-side is top of stack

func is_active() -> bool:
    return visible

func unpause() -> void:
    visible = false
    get_tree().paused = false

func pause() -> void:
    visible = true
    get_tree().paused = true
    control_stack.clear()
    control_stack.push_back($TopLevelPauseMenu)

func get_room():
    return get_parent().get_parent()

func push_control(ctrl) -> void:
    ctrl.on_push()
    control_stack.push_back(ctrl)

func pop_control():
    var ctrl = control_stack.pop_back()
    if ctrl != null:
        ctrl.on_pop()
    return ctrl

func _ready() -> void:
    $TopLevelPauseMenu.set_options($TopLevelOptions.TOP_LEVEL_OPTIONS)

func _process(_delta: float) -> void:
    if is_active():

        # Allow unpausing (DEBUG CODE as this will be somewhere else later)
        if Input.is_action_just_released("ui_cancel") or Input.is_action_just_released("ui_pause"):
            unpause()

        for action in CONTROL_STACK_ACTIONS:
            if Input.is_action_just_released(action):
                for i in range(len(control_stack) - 1, -1, -1):
                    var ctrl = control_stack[i]
                    if ctrl.handle_input(action):
                        break

    else:
        if Input.is_action_just_released("ui_pause") and not get_room().is_showing_modal():
            pause()