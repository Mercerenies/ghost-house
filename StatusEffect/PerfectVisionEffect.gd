extends StatusEffect

func get_id() -> int:
    return StatusEffect.ID_PerfectVisionEffect

func get_name() -> String:
    return "Perfect Vision"

func darkness_visibility_multiplier() -> float:
    return 99999.0
