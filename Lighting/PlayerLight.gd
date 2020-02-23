extends Node2D

var _alpha: float = 0.752941

func get_lighting():
    return get_node("../..")

func get_room():
    return get_lighting().get_room()

func set_direction(a: int) -> void:
    $Flashlight.rotation = a * PI / 2.0

func _on_PlayerStatusEffects_status_effects_changed():
    var visibility = (1 - _alpha)
    var mult = get_room().get_player_stats().get_status_effects().darkness_visibility_multiplier()
    $DarkBox.color.a = clamp(1 - visibility * mult, 0.0, 1.0)
