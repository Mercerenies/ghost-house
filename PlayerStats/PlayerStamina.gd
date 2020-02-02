extends Node2D

const STANDARD_COLOR = Color("#601527e2")
const FASTER_COLOR = Color("#6015e24e")
const SLOWER_COLOR = Color("#60e27015")

const EPSILON = 0.001

var _value: float = 100.0
var _change_per_sec: float = 100.0

func _ready() -> void:
    $StaminaMeter.value = _value
    var style = StyleBoxFlat.new()
    style.set_bg_color(STANDARD_COLOR)
    $StaminaMeter.set("custom_styles/fg", style)

func _process(delta: float) -> void:
    $StaminaMeter.value = Util.toward($StaminaMeter.value, _change_per_sec * delta, _value)

func set_stamina(a: float) -> void:
    _value = clamp(a, 0, 100)

func get_stamina() -> float:
    return _value

func jump_to_value() -> void:
    $StaminaMeter.value = _value

func set_color_based_on_rate_multiplier(restore_rate: float) -> void:
    var color
    if abs(restore_rate - 1.0) < EPSILON:
        color = STANDARD_COLOR
    elif restore_rate > 1.0:
        color = FASTER_COLOR
    else:
        color = SLOWER_COLOR
    $StaminaMeter.get("custom_styles/fg").set_bg_color(color)
