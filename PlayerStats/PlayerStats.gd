extends Node2D

var _status_effects: Array

func get_player_health() -> int:
    return $PlayerHealth.get_health()

func get_player_stamina() -> float:
    return $PlayerStamina.get_stamina()

func set_player_health(a: int) -> void:
    $PlayerHealth.set_health(a)

func set_player_stamina(a: float) -> void:
    $PlayerStamina.set_stamina(a)

func add_player_health(a: int) -> void:
    set_player_health(get_player_health() + a)

func add_player_stamina(a: float) -> void:
    set_player_stamina(get_player_stamina() + a)

func get_player_max_health() -> int:
    return $PlayerHealth.get_max_health()

func damage_player(a: int) -> bool:
    if has_iframe():
        return false
    add_player_health(- a)
    if a > 0:
        trigger_iframe()
        return true
    return false

func trigger_iframe() -> void:
    $PlayerIFrame.start()

func has_iframe() -> bool:
    return $PlayerIFrame.time_left > 0

func get_status_effects() -> Array:
    return _status_effects

func apply_status_effect(effect: StatusInstance) -> void:
    _status_effects.push_back(effect)

func _ready() -> void:
    _status_effects = []
    # DEBUG CODE
    #apply_status_effect(StatusInstance.new(load("res://StatusEffect/DebugEffect.gd").new(), -1))

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
