extends Node

signal status_effects_changed

var _status_effects: Array = []

func get_effect_list():
    return _status_effects

func apply_status_effect(effect: StatusInstance) -> void:
    if not effect.get_effect().can_stack():
        for curr in _status_effects:
            if curr.get_effect().get_id() == effect.get_effect().get_id():
                # If the effect we're trying to apply is permanent or longer
                # than the preexisting one, replace the length.
                if effect.get_length() < 0 or (curr.get_length() >= 0 and effect.get_length() > curr.get_length()):
                    curr.set_length(effect.get_length())
                return
    _status_effects.push_back(effect)
    emit_signal("status_effects_changed")

func stamina_recovery_rate_multiplier() -> float:
    var mult = 1.0
    for eff in get_effect_list():
        mult *= eff.get_effect().stamina_recovery_rate_multiplier()
    return mult

func player_damage_multiplier() -> int:
    var mult = 1
    for eff in get_effect_list():
        mult *= eff.get_effect().player_damage_multiplier()
    return mult

func darkness_visibility_multiplier() -> float:
    var mult = 1.0
    for eff in get_effect_list():
        mult *= eff.get_effect().darkness_visibility_multiplier()
    return mult

func can_dash() -> bool:
    for eff in get_effect_list():
        if not eff.get_effect().can_dash():
            return false
    return true

func _on_PlayerStatusEffectTimer_timeout():
    var j = 0
    for i in range(len(_status_effects)):
        var s = _status_effects[i]
        s.decrement_length()
        _status_effects[j] = _status_effects[i]
        if s.get_length() != 0:
            j += 1
    var need_to_purge = (len(_status_effects) > j)
    while len(_status_effects) > j:
        _status_effects.pop_back() # Purge expired status effects
    if need_to_purge:
        emit_signal("status_effects_changed")

func _ready() -> void:
    call_deferred("_tmp")

func _tmp() -> void:
    # DEBUG CODE
    #apply_status_effect(StatusInstance.new(load("res://StatusEffect/SlowedEffect.gd").new(), 10))
    pass
