extends StatusEffect

func get_id() -> int:
    return StatusEffectCodex.ID_BlindedEffect

func get_name() -> String:
    return "Blinded"

func get_icon_index() -> int:
    return 5

func darkness_visibility_multiplier() -> float:
    return 0.55
