extends FurnitureInteraction

const ItemCollectionVisual = preload("res://Item/ItemCollectionVisual.tscn")

var furniture
var interaction

func _init(furniture) -> void:
    self.furniture = furniture

func is_active() -> bool:
    return (furniture.get_stored_item() != null)

func perform_interaction() -> void:
    var stats = furniture.get_room().get_player_stats()
    var inv = stats.get_inventory()
    var item = furniture.get_stored_item()

    if inv.add_item(item):
        var visual = ItemCollectionVisual.instance()
        visual.set_item(item)
        visual.position = (furniture.get_dims() * 32) / 2
        furniture.set_stored_item(null)
        furniture.add_child(visual)

    # ///// Refine visual and then make a "full inventory" visual
