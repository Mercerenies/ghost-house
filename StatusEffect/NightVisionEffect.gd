extends StatusEffect

func get_id() -> int:
    return StatusEffect.ID_NightVisionEffect

func get_name() -> String:
    return "Night Vision"

func darkness_visibility_multiplier() -> float:
    return 1.4285
