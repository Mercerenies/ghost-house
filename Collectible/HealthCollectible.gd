extends  Collectible

const CollectionVisual = preload("res://FurnitureInteraction/CollectionVisual.tscn")
const HeartSprite = preload("res://PlayerStats/HeartSprite.tscn")

var _amount: int

func _init(amount: int = 1) -> void:
    _amount = amount

func get_tags() -> Array:
    return [CollectibleTag.IMMEDIATE]

# Returns whether successful
func perform_collection(furniture) -> bool:
    # TODO Should this fail and return false if the player's health is full?

    var room = furniture.get_room()
    var stats = room.get_player_stats()
    stats.add_player_health(_amount)

    var visual = CollectionVisual.instance()
    visual.get_node("ItemSprite").visible = false
    visual.get_node("BackgroundSprite").visible = false
    visual.add_child(HeartSprite.instance())
    visual.position = (furniture.get_dims() * 32) / 2
    furniture.add_child(visual)

    return true
