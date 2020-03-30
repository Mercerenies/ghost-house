extends Collectible

const CollectionVisual = preload("res://FurnitureInteraction/CollectionVisual.tscn")
const KeyImage = preload("res://PlayerStats/Key.png")

var _amount: int
var _appears_on_minimap: bool = false

func _init(amount: int = 1, minimap_flag: bool = false) -> void:
    _amount = amount
    _appears_on_minimap = minimap_flag

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

    if _appears_on_minimap:
        var minimap = room.get_minimap()
        var pos = RoomDimensions.cell_to_generator_cell(furniture.cell)
        var room_id = minimap.get_room_id_at_pos(pos)
        minimap.remove_icon(room_id, Icons.Index.KEY)

    return true
