extends Node2D

func get_player_health() -> int:
    return $PlayerHealth.get_health()

func get_player_stamina() -> float:
    return $PlayerStamina.get_stamina()

func set_player_health(a: int) -> void:
    $PlayerHealth.set_health(a)

func set_player_stamina(a: float) -> void:
    $PlayerStamina.set_stamina(a)

func add_player_health(a: float) -> void:
    set_player_health(get_player_health() + a)

func add_player_stamina(a: float) -> void:
    set_player_stamina(get_player_stamina() + a)

func damage_player(a: float) -> bool:
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
