extends StatusEffect

func get_id() -> int:
    return StatusEffect.ID_InvincibleEffect

func get_name() -> String:
    return "Invincible"

func player_damage_multiplier() -> int:
    return 0
