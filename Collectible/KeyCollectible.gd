extends  Collectible

const CollectionVisual = preload("res://FurnitureInteraction/CollectionVisual.tscn")
const KeyImage = preload("res://PlayerStats/Key.png")

var _amount: int

func _init(amount: int = 1) -> void:
    _amount = amount

func get_tags() -> Array:
    return [CollectibleTag.ESSENTIAL]

# Returns whether successful
func perform_collection(furniture) -> bool:
    var room = furniture.get_room()
    var stats = room.get_player_stats()
    stats.add_player_keys(_amount)

    var visual = CollectionVisual.instance()
    var sprite = Sprite.new()
    sprite.texture = KeyImage
    visual.get_node("BackgroundSprite").visible = false
    visual.add_child(sprite)
    visual.position = (furniture.get_dims() * 32) / 2
    furniture.add_child(visual)

    return true
