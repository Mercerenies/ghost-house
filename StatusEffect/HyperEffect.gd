extends StatusEffect

func get_id() -> int:
    return StatusEffectCodex.ID_HyperEffect

func get_name() -> String:
    return "Hyper"

func get_icon_index() -> int:
    return 3

func can_stack() -> bool:
    return true

func stamina_recovery_rate_multiplier() -> float:
    return 2.0
