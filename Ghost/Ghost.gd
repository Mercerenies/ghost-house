extends DialogueEntity

var invisible: bool = true

func _ready() -> void:
    $Sprite.visible = false
    dialogue = {
        "idle": [
            {"command": "say", "speaker": "A Ghost", "text": "Hi, I'm a ghost :)"}
        ]
    }
    unposition_self()
    modulate.a = 0
    invisible = true

func _process(delta: float) -> void:

    if invisible:
        var player = EnemyAI.get_player(self)
        var flashlight = player.flashlight_triangle()
        var flashlight_rad = player.base_flashlight_radius()
        var player_dist = EnemyAI.distance_to_player(self)

        var in_triangle = Util.point_in_polygon(position + Vector2(16, 16), flashlight)
        var in_circle = player_dist < flashlight_rad
        if in_triangle or in_circle:
            modulate.a = Util.toward(modulate.a, delta / 2, 1)
            var current_cell = Vector2(floor(position.x / 32), floor(position.y / 32))
            var cell_entity = get_room().get_entity_cell(current_cell)
            if modulate.a == 1 and cell_entity == null:
                get_room().set_entity_cell(current_cell, self)
                cell = current_cell
        else:
            modulate.a = Util.toward(modulate.a, delta / 4, 0)

func on_interact() -> void:
    var player = get_room().get_marked_entities()['player']
    var dir = atan2(player.global_position.y - global_position.y, player.global_position.x - global_position.x)
    dir = round(fmod((4 * dir) / (2 * PI), 4))
    dir = fmod(dir + 4, 4)
    set_direction(dir)
    get_room().show_dialogue(dialogue, "idle")
