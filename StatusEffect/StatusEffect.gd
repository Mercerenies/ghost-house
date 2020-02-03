extends Reference
class_name StatusEffect

const ID_DebugEffect = 1
const ID_TiredEffect = 2
const ID_HyperEffect = 3
const ID_InvincibleEffect = 4
const ID_BlindedEffect = 5
const ID_NightVisionEffect = 6

func get_id() -> int:
    return 0

func get_name() -> String:
    return ""

# If true, the status effect can stack, meaning it can be applied to the
# player multiple times. If false, the effect will not stack and, if applied
# multiple times, will simply take the maximum of the two times and remain
# applied only once. The default is false.
func can_stack() -> bool:
    return false

func stamina_recovery_rate_multiplier() -> float:
    return 1.0

func player_damage_multiplier() -> int:
    return 1

func darkness_visibility_multiplier() -> float:
    return 1.0