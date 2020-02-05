extends DialogueEntity

const GhostVisibilityParticle = preload("res://Ghost/GhostVisibilityParticle.tscn")
const GhostNamer = preload("res://GhostNamer/GhostNamer.gd")
const MaleGhost = preload("res://Ghost/MaleGhost.png")
const FemaleGhost = preload("res://Ghost/FemaleGhost.png")
const GeneratorPlacementHelper = preload("res://GeneratorPlacementHelper/GeneratorPlacementHelper.gd")

const OFFSCREEN = Vector2(-3200, -3200)

var appearing: bool = false
var invisible: bool = true

func _ready() -> void:
    $Sprite.visible = false
    _update_dialogue()
    call_deferred("_establish_appearance")
    unposition_self()
    modulate.a = 0
    invisible = true
    position = OFFSCREEN
    target_pos = OFFSCREEN

func _establish_appearance() -> void:
    var gender = Util.choose([GhostNamer.Gender.Male, GhostNamer.Gender.Female])
    var color = Util.choose(GhostColors.color_constants())
    get_sprite().texture = MaleGhost if gender == GhostNamer.Gender.Male else FemaleGhost
    $DropSprite.frame = 0 if gender == GhostNamer.Gender.Male else 1
    get_sprite().modulate = GhostColors.color_constant_to_color(color)
    $DropSprite.modulate = GhostColors.color_constant_to_color(color)

func _update_dialogue() -> void:
    dialogue = {}
    dialogue['idle'] = [
        { "command": "say", "speaker": "???", "text": "Ooohohohohohoho!" },
        { "command": "action", "action": "harm_player", "arg": 1 },
        { "command": "action", "action": "furniture_drop", "arg": $DropSprite }
    ]

func is_inactive() -> bool:
    return position.x <= OFFSCREEN.x

func try_to_place() -> void:
    if is_inactive():
        var room: Room = get_room()
        var minimap = room.get_minimap()
        var bounds = room.get_room_bounds()
        var pos = Vector2(Util.randi_range(bounds.position.x, bounds.end.x),
                          Util.randi_range(bounds.position.y, bounds.end.y))
        if GeneratorPlacementHelper.is_blocked(room, pos):
            return # Position is blocked.
        var target_room = minimap.get_room_id_at_pos(pos)
        if target_room != null:
            var icons = minimap.get_icons(target_room)
            for icn in icons:
                if icn >= Icons.Index.FIRST_GHOST and icn < Icons.Index.FIRST_GHOST + 26:
                    return # There's another ghost in this room, so don't select this one.
        position = pos * 32
        target_pos = pos * 32
        print(position / 32)

func _process(delta: float) -> void:

    if is_inactive():
        invisible = true
        modulate.a = 0

    elif invisible:
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
                $WanderTimer.start()
        else:
            appearing = false
            modulate.a = Util.toward(modulate.a, delta / 8, 0)

func on_interact() -> void:
    var player = get_room().get_marked_entities()['player']
    var dir = atan2(player.global_position.y - global_position.y, player.global_position.x - global_position.x)
    dir = round(fmod((4 * dir) / (2 * PI), 4))
    dir = fmod(dir + 4, 4)
    set_direction(dir)
    get_room().show_dialogue(dialogue, "idle")

func _on_AppearParticleTimer_timeout():
    if appearing and invisible:
        var part = GhostVisibilityParticle.instance()
        part.position = Vector2(randf() * 32, randf() * 32)
        self.add_child(part)

func _on_WanderTimer_timeout():
    if get_room().is_showing_modal() or invisible or is_inactive():
        return

    var minimap = get_room().get_minimap()
    var dir = randi() % 4
    var destination
    for _i in range(4):
        dir = (dir + 1) % 4
        destination = self.cell + Vector2(1, 0).rotated(dir * PI / 2)
        if not can_move_to(destination):
            continue
        if minimap.is_initialized():
            var p0 = Vector2(floor(self.cell.x / 32), floor(self.cell.y / 32))
            var p1 = Vector2(floor(destination.x / 32), floor(destination.y / 32))
            if minimap.get_room_id_at_pos(p0) != minimap.get_room_id_at_pos(p1):
                continue
        set_direction(dir)
        if try_move_to(destination):
            break

func _on_PlacementTimer_timeout():
    if get_room().is_showing_modal():
        return
    if is_inactive():
        try_to_place()
