extends Item

func get_id() -> int:
    return Item.ID_DebugItem

func get_name() -> String:
    return "Debug Item"

func get_description() -> String:
    return "An item intended for debug purposes. Has no effect."

func get_icon_index() -> int:
    return 1
