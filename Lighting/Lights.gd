extends Node2D

func _ready():
    pass

func get_lighting():
    return get_parent().get_lighting()

func get_room():
    return get_lighting().get_room()

func find_player():
    return get_lighting().find_player()

func _process(_delta: float) -> void:
    update()

func _draw() -> void:
    var player = find_player()
    var player_pos = player.position if player != null else Vector2()
    var transform = player_pos - get_parent().get_parent().size / 2.0
    for ent in get_room().get_entities():
        var lighting = ent.lighting()
        for a in lighting:
            match a['type']:
                'circle':
                    draw_circle(a['position'] - transform, a['radius'], a['color'])
                'flashlight':
                    var pos = a['position']
                    var fov = a['fov']
                    var range_ = a['range']
                    var points = PoolVector2Array()
                    points.push_back(pos - transform)
                    points.push_back(pos + Vector2(range_.length(), range_.length() * tan(fov / 2.0)).rotated(range_.angle()) - transform)
                    points.push_back(pos + Vector2(range_.length(), - range_.length() * tan(fov / 2.0)).rotated(range_.angle()) - transform)
                    var colors = PoolColorArray([a['color']])
                    draw_polygon(points, colors)