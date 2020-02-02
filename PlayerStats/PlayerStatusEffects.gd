extends Node

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

func _on_PlayerStatusEffectTimer_timeout():
    var j = 0
    for i in range(len(_status_effects)):
        var s = _status_effects[i]
        s.decrement_length()
        _status_effects[j] = _status_effects[i]
        if s.get_length() > 0:
            j += 1
    while len(_status_effects) > j:
        _status_effects.pop_back() # Purge expired status effects

func _ready() -> void:
    # DEBUG CODE
    apply_status_effect(StatusInstance.new(load("res://StatusEffect/DebugEffect.gd").new(), 60))
    pass
