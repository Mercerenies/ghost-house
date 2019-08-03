extends Reference
class_name EdgePlacementManager

var _placements: Array
var _pindices: Array

# Pass dictionaries of the form { "placement": obj, "chance": weight }
func _init(placements: Array) -> void:
    _placements = placements

func generate_at_position(pos: Vector2, dir: int, max_width: int):
    var count = 0
    for pl in _placements:
        if pl["placement"].get_width() > max_width:
            continue
        count += pl["chance"]
    var choice = randi() % count
    for pl in _placements:
        if pl["placement"].get_width() > max_width:
            continue
        choice -= pl["chance"]
        if choice < 0.0:
            return pl["placement"].spawn_at(pos, dir)
    # If we get to this point, badness happened.
    return null