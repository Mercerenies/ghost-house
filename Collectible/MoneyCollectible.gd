extends  Collectible

const MoneyCollectionAnimation = preload("res://Collectible/MoneyCollectionAnimation.tscn")

var _amount: int

func _init(amount: int) -> void:
    _amount = amount

func get_tags() -> Array:
    return [CollectibleTag.IMMEDIATE]

# Returns whether successful
func perform_collection(furniture) -> bool:
    var room = furniture.get_room()
    var stats = room.get_player_stats()
    stats.add_player_money(_amount)

    # We want total_money_transferred = part_amount * part_timer / part_lifetime
    var visual = MoneyCollectionAnimation.instance()
    visual.amount = max(1, _amount * visual.lifetime / visual.get_node("Timer").wait_time)
    visual.lifetime += 0.02 # Fixes an off-by-one error on the visuals
    visual.position = (furniture.get_dims() * 32) / 2
    furniture.add_child(visual)

    return true
