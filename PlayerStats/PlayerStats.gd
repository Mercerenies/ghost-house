extends Node2D

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

    a *= $PlayerStatusEffects.player_damage_multiplier()

    add_player_health(- a)
    if a > 0:
        trigger_iframe()
        return true
    return false

func trigger_iframe() -> void:
    if not has_iframe():
        $PlayerIFrame.start()

func has_iframe() -> bool:
    return $PlayerIFrame.time_left > 0

func get_status_effects():
    return $PlayerStatusEffects

func get_inventory():
    return $PlayerInventory

func _on_PlayerStatusEffects_status_effects_changed():
    $PlayerStamina.set_color_based_on_rate_multiplier($PlayerStatusEffects.stamina_recovery_rate_multiplier())
