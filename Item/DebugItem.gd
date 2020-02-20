extends Item

func get_id() -> int:
    return Item.ID_DebugItem

func get_name() -> String:
    return "Debug Item"

func get_description() -> String:
    return "An item intended for debug purposes. Has no effect."

func get_icon_index() -> int:
    return 1

func _get_actions_app(out: Array):
    out.append(ACTION_DROP)
    ._get_actions_app(out)

static func action_name(action: int) -> String:
    return .action_name(action)
