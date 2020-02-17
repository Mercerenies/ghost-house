extends Node

# We store this in PlayerStats for consistency. It doesn't actually
# draw here, but since other player data (health, stamina, status
# effects, etc.) are stored here, might as well put it here as well.

var _items: Array = []

# Like with PlayerStatusEffects, consider this list pseudo-immutable.
# That is, you may read from the list and mutate specific elements of
# it, but do not add or delete elements from the list. Instead, use
# the functions in this node to add or delete items.
func get_item_list() -> Array:
    return _items

func add_item(item: ItemInstance) -> void:
    _items.append(item)

func remove_item(index: int) -> void:
    _items.remove(index)
