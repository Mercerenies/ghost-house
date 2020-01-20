extends Node

func get_player(entity):
    return entity.get_room().get_marked_entities()['player']

func distance_to_player(entity):
    var player = get_player(entity)
    return (player.global_position - entity.global_position).length()

func player_line_of_sight(entity):
    # Returns the angle between the player's line of sight and this object. A higher value (up
    # to PI) implies that the player is facing away from the object. A lower value (down to 0)
    # implies the player is facing toward it.
    var player = get_player(entity)
    var vec = entity.position - player.position
    var player_line_of_sight = Vector2(1, 0).rotated(player.get_direction() * PI / 2.0)
    return abs(vec.angle_to(player_line_of_sight))
