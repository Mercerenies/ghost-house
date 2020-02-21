extends StatusEffect

func get_id() -> int:
    return StatusEffectCodex.ID_NightVisionEffect

func get_name() -> String:
    return "Night Vision"

func get_icon_index() -> int:
    return 6

func darkness_visibility_multiplier() -> float:
    return 1.8182
