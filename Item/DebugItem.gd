extends Item

const ACTION_USE = 3001

const DIALOGUE_ON_USE = {
    "start": [
        { "command": "say", "text": "You use the Debug Item." },
        { "command": "say", "text": "You feel kinda funny..." },
        { "command": "end" },
    ]
}

func get_id(_instance) -> int:
    return ItemCodex.ID_DebugItem

func get_name(_instance) -> String:
    return "Debug Item"

func get_description(_instance) -> String:
    return "An item intended for debug purposes. Has no effect."

func get_icon_index(_instance) -> int:
    return 1

func get_tags(_instance) -> Array:
   return [ItemTag.DEBUG]

func _get_actions_app(out: Array, instance):
    out.append(ACTION_USE)
    out.append(ACTION_DROP)
    ._get_actions_app(out, instance)

func do_action(room: Room, instance, action_id: int) -> void:
    match action_id:
        ACTION_USE:
            room.get_pause_menu().unpause()
            room.get_dialogue_box().popup(DIALOGUE_ON_USE, "start")
            room.get_player_stats().get_inventory().erase_item(instance)
        _:
            .do_action(room, instance, action_id)

static func action_name(action: int) -> String:
    match action:
        ACTION_USE:
            return "Use"
        _:
            return .action_name(action)

