extends Reference
class_name StatusInstance

var _effect: StatusEffect
var _length: int # in seconds, -1 means permanent

func _init(effect: StatusEffect, length: int) -> void:
    _effect = effect
    _length = length

func get_effect() -> StatusEffect:
    return _effect

func get_length() -> int:
    return _length

func decrement_length() -> void:
    if _length != 0:
        _length -= 1

func expire() -> void:
    _length = 0

func to_display_string() -> String:
    if get_length() < 0:
        return get_effect().get_name()
    else:
        # warning-ignore: integer_division
        var time_display = "%d:%02d" % [get_length() / 60, get_length() % 60]
        return "{} (Left {})".format([get_effect().get_name(), time_display], "{}")