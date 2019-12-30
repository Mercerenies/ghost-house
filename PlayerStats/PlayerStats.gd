extends Node2D

var _playerstamina = 100.0
var _change_per_sec = 100.0

func _ready() -> void:
    $PlayerStamina.value = _playerstamina

func _process(delta: float) -> void:
    $PlayerStamina.value = Util.toward($PlayerStamina.value, _change_per_sec * delta, _playerstamina)

func get_player_health() -> float:
    return $PlayerHealth.get_health()

func get_player_stamina() -> float:
    return _playerstamina

func set_player_health(a: float) -> void:
    $PlayerHealth.set_health(a)

func set_player_stamina(a: float) -> void:
    _playerstamina = clamp(a, 0, 100)

func add_player_health(a: float) -> void:
    set_player_health(get_player_health() + a)

func add_player_stamina(a: float) -> void:
    set_player_stamina(get_player_stamina() + a)

func damage_player(a: float) -> void:
    if has_iframe():
        return
    add_player_health(- a)
    if a > 0:
        trigger_iframe()

func trigger_iframe() -> void:
    $PlayerIFrame.start()

func has_iframe() -> bool:
    return $PlayerIFrame.time_left > 0