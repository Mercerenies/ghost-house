extends  Collectible

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

    # TODO Animation
    print("Money")

    return true
