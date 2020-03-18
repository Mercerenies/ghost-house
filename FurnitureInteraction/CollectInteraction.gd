extends FurnitureInteraction

const CollectionVisual = preload("CollectionVisual.tscn")

var furniture

func _init(furniture) -> void:
    self.furniture = furniture

func is_active() -> bool:
    return (furniture.get_storage() != null)

func perform_interaction() -> void:
    var storage = furniture.get_storage()
    if storage.perform_collection(furniture):
        furniture.set_storage(null)
