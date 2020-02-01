extends Node2D

var _value: float = 100.0
var _change_per_sec: float = 100.0

func _ready() -> void:
    $StaminaMeter.value = _value

func _process(delta: float) -> void:
    $StaminaMeter.value = Util.toward($StaminaMeter.value, _change_per_sec * delta, _value)

func set_stamina(a: float) -> void:
    _value = clamp(a, 0, 100)

func get_stamina() -> float:
    return _value