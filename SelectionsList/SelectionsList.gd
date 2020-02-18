extends Node2D

export var wrap_around: bool = true

var _options: Array = []
var _option: int = 0

func _update_self():
    $Label.text = ""
    for opt in _options:
        $Label.text += opt["text"] + '\n'
    call_deferred("_update_text") # Need to give the label a frame to update itself.

func _update_text():

    var height0 = ($Label.get_line_height()) * ($Label.get_line_count() - 1)
    $Label.rect_size.y = height0 - 4
    var line_height = $Label.rect_size.y / (len(_options) + 1)
    var height = $Label.rect_size.y

    $CurrentOption.visible = (len(_options) != 0)

    $CurrentOption.position = $Label.rect_position + Vector2(-16, $Label.get_line_height() / 2)
    $CurrentOption.position.y += line_height * _option

func update() -> void:
    _update_self()
    .update()

# Each entry should be a dictionary containing an integer "id" field
# and a string "text" field.
func set_options(options: Array) -> void:
    _options = options
    _update_self()

func get_options() -> Array:
    return _options

func set_selected_option_index(index: int) -> void:
    if len(_options) != 0:
        if wrap_around:
            _option = (index % len(_options) + len(_options)) % len(_options)
        else:
            _option = clamp(index, 0, len(_options) - 1)
    _update_self()

func get_selected_option_index() -> int:
    return _option

func get_selected_option() -> Dictionary:
    if len(_options) == 0:
        return {} # "Null"
    return _options[_option]

func get_text_rect() -> Rect2:
    return $Label.get_rect()

func cursor_down() -> void:
    set_selected_option_index(get_selected_option_index() + 1)

func cursor_up() -> void:
    set_selected_option_index(get_selected_option_index() - 1)
