extends Reference
class_name Item

const ID_DebugItem = 1

# Item actions are integer ID values. These values obey the following
# scheme. Any integer values not listed below are reserved for future
# use.
#
#  1001-2000: Generic IDs that are used for special pause menu
#  functionality and should not be used by items.
#
#  2001-3000: Special IDs that are used for common functions. These
#  IDs have values defined here, which can be used by items and should
#  be used for their intended meaning.
#
#  3001-4000: Ordinary IDs which are unreserved and free for items to
#  use to whatever end they please.

const ACTION_CANCEL = 1001

const ACTION_DROP = 2001

func get_id() -> int:
    return 0

func get_name() -> String:
    return ""

func get_description() -> String:
    return ""

func get_icon_index() -> int:
    return 0

# Appends the actions for this item to the array argument.
func _get_actions_app(out: Array) -> void:
    pass

# Returns an array of action IDs. Do not override this method;
# override _get_actions_app() instead, which this method calls.
func get_actions() -> Array:
    var arr = []
    _get_actions_app(arr)
    return arr

# The default Item implementation handles special IDs and performs no
# action on others. Override this method to handle ordinary IDs and
# call the parent in any unhandled cases.
func do_action(room: Room, instance, action_id: int) -> void:
    match action_id:
        ACTION_DROP:
            # TODO Maybe an animation? Idk
            room.get_player_stats().get_inventory().erase_item(instance)

# Given an action ID associated with the given item, returns the name
# of the action. Should be overridden in subclasses to account for
# item-specific actions (IDs 3001-4000)
static func action_name(action: int) -> String:
    match action:
        ACTION_CANCEL:
            return "Cancel"
        ACTION_DROP:
            return "Drop"
    return ""
