extends Node

# We store this in PlayerStats for consistency. It doesn't actually
# draw here, but since other player data (health, stamina, status
# effects, etc.) are stored here, might as well put it here as well.

const DEFAULT_MAX_INV_SIZE = 20

var _items: Array = []
var _max_items: int = DEFAULT_MAX_INV_SIZE

# Like with PlayerStatusEffects, consider this list pseudo-immutable.
# That is, you may read from the list and mutate specific elements of
# it, but do not add or delete elements from the list. Instead, use
# the functions in this node to add or delete items.
func get_item_list() -> Array:
    return _items

func get_item_count() -> int:
    return len(_items)

# Returns whether successful. This function will fail if the player's
# inventory is full.
func add_item(item: ItemInstance) -> bool:
    if len(_items) < _max_items:
        _items.append(item)
        return true
    else:
        return false

func remove_item(index: int) -> void:
    _items.remove(index)

func erase_item(item: ItemInstance) -> void:
    _items.erase(item)
