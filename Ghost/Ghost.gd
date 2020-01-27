extends DialogueEntity

const GhostVisibilityParticle = preload("GhostVisibilityParticle.tscn")

var appearing: bool = false
var invisible: bool = true
var ghost_name: String = ""
var ghost_clue = null

func _ready() -> void:
    $Sprite.visible = false
    _update_dialogue()
    unposition_self()
    modulate.a = 0
    invisible = true

func set_name(name: String) -> void:
    ghost_name = name
    _update_dialogue()

func set_clue(clue) -> void:
    ghost_clue = clue
    _update_dialogue()

func _update_dialogue() -> void:
    dialogue = {}
    dialogue['idle'] = [
        { "command": "say", "speaker": ghost_name, "text": "Hi, I'm a ghost. My name is " + ghost_name + " :)" }, # DEBUG CODE
    ]
    if ghost_clue != null:
        var clue_text = StatementPrinter.translate(ghost_clue)
        dialogue['clue'] = [
            { "command": "say", "speaker": ghost_name, "text": clue_text + "." }
        ]

func _process(delta: float) -> void:

    if invisible:
        var player = EnemyAI.get_player(self)
        var flashlight = player.flashlight_triangle()
        var flashlight_rad = player.base_flashlight_radius()
        var player_dist = EnemyAI.distance_to_player(self)

        var in_triangle = Util.point_in_polygon(position + Vector2(16, 16), flashlight)
        var in_circle = player_dist < flashlight_rad
        if in_triangle or in_circle:
            appearing = true
            modulate.a = Util.toward(modulate.a, delta / 4, 1)
            var current_cell = Vector2(floor(position.x / 32), floor(position.y / 32))
            var cell_entity = get_room().get_entity_cell(current_cell)
            if modulate.a == 1 and cell_entity == null:
                get_room().set_entity_cell(current_cell, self)
                cell = current_cell
                invisible = false
                $AppearParticleTimer.stop()
        else:
            appearing = false
            modulate.a = Util.toward(modulate.a, delta / 8, 0)

func on_interact() -> void:
    var player = get_room().get_marked_entities()['player']
    var dir = atan2(player.global_position.y - global_position.y, player.global_position.x - global_position.x)
    dir = round(fmod((4 * dir) / (2 * PI), 4))
    dir = fmod(dir + 4, 4)
    set_direction(dir)
    if "clue" in dialogue:
        get_room().show_dialogue(dialogue, "clue")
    else:
        get_room().show_dialogue(dialogue, "idle")

func _on_AppearParticleTimer_timeout():
    if appearing and invisible:
        var part = GhostVisibilityParticle.instance()
        part.position = Vector2(randf() * 32, randf() * 32)
        self.add_child(part)
