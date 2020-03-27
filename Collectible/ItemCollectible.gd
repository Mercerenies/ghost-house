extends  Collectible

const CollectionVisual = preload("res://FurnitureInteraction/CollectionVisual.tscn")
const ItemSprite = preload("res://Item/ItemSprite.tscn")
const CollectionVisualImage = preload("res://FurnitureInteraction/CollectionVisual.png")

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
    var item_sprite = ItemSprite.instance()
    item_sprite.frame = item.get_icon_index()
    visual.add_child(item_sprite)
    visual.position = (furniture.get_dims() * 32) / 2
    furniture.add_child(visual)

    # We copy the item here to ensure that this ItemCollectible
    # remains immutable, even if the player or the player's inventory
    # later modifies the ItemInstance. This allows ItemCollectible
    # instances to be shared across different articles of furniture.
    if inv.add_item(item.copy()):
        return true
    else:
        var no_room = Sprite.new()
        no_room.texture = CollectionVisualImage
        no_room.hframes = 2
        no_room.frame = 1
        visual.add_child(no_room)
        return false
