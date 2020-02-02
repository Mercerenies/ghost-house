extends StatusEffect

func get_id() -> int:
    return StatusEffect.ID_HyperEffect

func get_name() -> String:
    return "Hyper"

func can_stack() -> bool:
    return true

func stamina_recovery_rate_multiplier() -> float:
    return 2.0
