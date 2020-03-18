extends  Collectible

const CollectionVisual = preload("res://FurnitureInteraction/CollectionVisual.tscn")

var _instance: ItemInstance

func _init(instance: ItemInstance) -> void:
    _instance = instance

func get_tags() -> Array:
    return _instance.get_tags()

# Returns whether successful
func perform_collection(furniture) -> bool:
    var room = furniture.get_room()
    var stats = room.get_player_stats()
    var inv = stats.get_inventory()
    var item = _instance

    var visual = CollectionVisual.instance()
    visual.set_item(item)
    visual.position = (furniture.get_dims() * 32) / 2
    furniture.add_child(visual)

    if inv.add_item(item):
        return true
    else:
        visual.show_no_room_message()
        return false
