extends Node2D

const CollectionVisual = preload("res://FurnitureInteraction/CollectionVisual.tscn")
const KeyImage = preload("res://PlayerStats/Key.png")

func get_room():
    return get_node("../..")

func get_player_health() -> int:
    return $PlayerHealth.get_health()

func get_player_stamina() -> float:
    return $PlayerStamina.get_stamina()

func get_player_money() -> int:
    return $PlayerMoney.get_money()

func get_player_keys() -> int:
    return $PlayerKeys.get_keys()

func set_player_health(a: int) -> void:
    $PlayerHealth.set_health(a)

func set_player_stamina(a: float) -> void:
    $PlayerStamina.set_stamina(a)

func set_player_money(a: int) -> void:
    $PlayerMoney.set_money(a)

func set_player_keys(a: int) -> void:
    $PlayerKeys.set_keys(a)

func add_player_health(a: int) -> void:
    set_player_health(get_player_health() + a)

func add_player_stamina(a: float) -> void:
    set_player_stamina(get_player_stamina() + a)

func add_player_money(a: int) -> void:
    set_player_money(get_player_money() + a)

func add_player_keys(a: int) -> void:
    set_player_keys(get_player_keys() + a)

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

func consume_key() -> void:
    add_player_keys(-1)
    var marked = get_room().get_marked_entities()
    if marked.has(Mark.PLAYER):
        var player = marked[Mark.PLAYER]
        var visual = CollectionVisual.instance()
        var sprite = Sprite.new()
        sprite.texture = KeyImage
        visual.get_node("BackgroundSprite").visible = false
        visual.add_child(sprite)
        player.add_child(visual)

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
