extends StatusEffect

func get_id() -> int:
    return StatusEffect.ID_DarknessEffect

func get_name() -> String:
    return "Darkness"

func get_icon_index() -> int:
    return 0 # TODO This icon

func darkness_visibility_multiplier() -> float:
    return 0.0
