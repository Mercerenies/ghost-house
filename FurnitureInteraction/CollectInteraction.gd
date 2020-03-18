extends FurnitureInteraction

const CollectionVisual = preload("CollectionVisual.tscn")

var furniture

func _init(furniture) -> void:
    self.furniture = furniture

func is_active() -> bool:
    return (furniture.get_storage() != null)

func perform_interaction() -> void:
    var stats = furniture.get_room().get_player_stats()
    var inv = stats.get_inventory()
    var item = furniture.get_storage()

    var visual = CollectionVisual.instance()
    visual.set_item(item)
    visual.position = (furniture.get_dims() * 32) / 2

    if inv.add_item(item):
        furniture.set_storage(null)
    else:
        visual.show_no_room_message()

    furniture.add_child(visual)
