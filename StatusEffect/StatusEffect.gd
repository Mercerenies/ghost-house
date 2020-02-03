extends Reference
class_name StatusEffect

const ID_DebugEffect = 1
const ID_TiredEffect = 2
const ID_HyperEffect = 3
const ID_InvincibleEffect = 4
const ID_BlindedEffect = 5
const ID_NightVisionEffect = 6
const ID_DarknessEffect = 7
const ID_PerfectVisionEffect = 8
const ID_SlowedEffect = 9

func get_id() -> int:
    return 0

func get_name() -> String:
    return ""

func get_icon_index() -> int:
    return 0

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

func can_dash() -> bool:
    return true
