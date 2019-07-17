extends Node2D

var _options: Array = []
var _option: int = 0
var _base_label_y: int
var _base_frame_y: int

func _ready():
    _base_label_y = $Label.rect_position.y
    _base_frame_y = $Frame.polygon[1].y - 4

func _update_self():
    $Label.text = ""
    for opt in _options:
        $Label.text += opt['text'] + '\n';
    call_deferred("_update_text")

func _update_text():
    var height = ($Label.get_line_height()) * ($Label.get_line_count() - 1)
    $Label.rect_position.y = _base_frame_y - height + 4
    $Frame.polygon[0].y = _base_frame_y - (height + 4)
    $Frame.polygon[1].y = _base_frame_y - (height + 4)
    $Frame.polygon[4].y = _base_frame_y - (height + 4)
    $CurrentOption.position = $Label.rect_position + Vector2(-16, $Label.get_line_height() / 2)
    var line_height = $Label.rect_size.y / (len(_options) + 1)
    $CurrentOption.position.y += line_height * _option

func popup(options: Array) -> void:
    _options = options
    _option = 0
    visible = true
    _update_self()

func hide() -> void:
    visible = false

func is_active() -> bool:
    return visible

func get_chosen_option() -> Dictionary:
    return _options[_option]

func _process(_delta: float) -> void:
    if visible:
        var dir = int(Input.is_action_just_released("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
        if dir != 0:
            _option += dir
            _option = (_option % len(_options) + len(_options)) % len(_options)
            _update_self()
    _update_text()