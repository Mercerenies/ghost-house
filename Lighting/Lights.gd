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
    var transform = find_player().position - get_parent().get_parent().size / 2.0
    for ent in get_room().get_entities():
        var lighting = ent.lighting()
        for a in lighting:
            draw_circle(a['position'] - transform, a['radius'], Color(1, 1, 1, 1))
