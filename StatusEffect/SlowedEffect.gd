extends StatusEffect

func get_id() -> int:
    return StatusEffect.ID_SlowedEffect

func get_name() -> String:
    return "Slowed"

func can_dash() -> bool:
    return false
