extends Reference
class_name StatusEffect

const ID_DebugEffect = 1

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
