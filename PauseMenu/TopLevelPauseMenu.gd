extends Node2D

signal option_selected(option)

var _options: Array = []
var _option: int = 0

func _update_self():
    $Label.text = ""
    for opt in _options:
        $Label.text += opt + '\n'
    call_deferred("_update_text") # Need to give the label a frame to update itself.

func _update_text():

    var height0 = ($Label.get_line_height()) * ($Label.get_line_count() - 1)
    $Label.rect_size.y = height0 - 4
    var line_height = $Label.rect_size.y / (len(_options) + 1)
    var height = $Label.rect_size.y

    $Frame.polygon[2].y = $Frame.polygon[1].y + height + 8
    $Frame.polygon[3].y = $Frame.polygon[0].y + height + 8

    $CurrentOption.position = $Label.rect_position + Vector2(-16, $Label.get_line_height() / 2)
    $CurrentOption.position.y += line_height * _option

func set_options(options: Array) -> void:
    _options = options
    _update_self()

func get_chosen_option() -> Dictionary:
    return _options[_option]

func on_push() -> void:
    _option = 0
    _update_self()

func on_pop() -> void:
    pass

func _ready() -> void:
    _update_self()

func handle_input(input_type: String) -> bool:
    match input_type:
        "ui_down":
            _option += 1
            _option = (_option % len(_options) + len(_options)) % len(_options)
            _update_self()
        "ui_up":
            _option -= 1
            _option = (_option % len(_options) + len(_options)) % len(_options)
            _update_self()
        "ui_accept":
            emit_signal("option_selected", get_chosen_option())
        "ui_cancel":
            get_parent().unpause()
    return true # Modal
