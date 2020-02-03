extends StatusEffect

func get_id() -> int:
    return StatusEffect.ID_BlindedEffect

func get_name() -> String:
    return "Blinded"

func darkness_visibility_multiplier() -> float:
    return 0.7
