extends StatusEffect

func get_id() -> int:
    return StatusEffect.ID_InvincibleEffect

func get_name() -> String:
    return "Invincible"

func get_icon_index() -> int:
    return 0 # TODO This

func player_damage_multiplier() -> int:
    return 0
