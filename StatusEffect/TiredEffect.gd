extends StatusEffect

func get_id() -> int:
    return StatusEffect.ID_TiredEffect

func get_name() -> String:
    return "Tired"

func get_icon_index() -> int:
    return 2

func can_stack() -> bool:
    return true

func stamina_recovery_rate_multiplier() -> float:
    return 0.5
