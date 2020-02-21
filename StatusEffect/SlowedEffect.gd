extends StatusEffect

func get_id() -> int:
    return StatusEffectCodex.ID_SlowedEffect

func get_name() -> String:
    return "Slowed"

func get_icon_index() -> int:
    return 9

func can_dash() -> bool:
    return false
