extends Node2D

var _playerhealth = 100.0
var _playerstamina = 100.0
var _change_per_sec = 100.0

func _ready() -> void:
    $PlayerHealth.value = _playerhealth
    $PlayerStamina.value = _playerstamina

func _process(delta: float) -> void:
    $PlayerHealth.value = Util.toward($PlayerHealth.value, _change_per_sec * delta, _playerhealth)
    $PlayerStamina.value = Util.toward($PlayerStamina.value, _change_per_sec * delta, _playerstamina)

func get_player_health() -> float:
    return _playerhealth

func get_player_stamina() -> float:
    return _playerstamina

func set_player_health(a: float) -> void:
    _playerhealth = clamp(a, 0, 100)

func set_player_stamina(a: float) -> void:
    _playerstamina = clamp(a, 0, 100)

func add_player_health(a: float) -> void:
    set_player_health(get_player_health() + a)

func add_player_stamina(a: float) -> void:
    set_player_stamina(get_player_stamina() + a)
