extends StatusEffect

func get_id() -> int:
    return StatusEffectCodex.ID_DarknessEffect

func get_name() -> String:
    return "Darkness"

func get_icon_index() -> int:
    return 7

func darkness_visibility_multiplier() -> float:
    return 0.0
