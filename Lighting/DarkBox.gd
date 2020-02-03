extends Polygon2D

var _alpha: float = 0.752941

func _ready():
    color.a = _alpha

func get_lighting():
    return get_parent().get_parent()

func get_room():
    return get_lighting().get_room()

func find_player():
    return get_lighting().find_player()

func _on_PlayerStatusEffects_status_effects_changed():
    var visibility = (1 - _alpha)
    var mult = get_room().get_player_stats().get_status_effects().darkness_visibility_multiplier()
    color.a = 1 - visibility * mult
