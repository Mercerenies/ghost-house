extends Node2D

const COLOR_ROOM = Color(1, 1, 1, 0.5)
const COLOR_CURRENT_ROOM = Color(1, 0, 0, 0.5)
const COLOR_BOUNDARY = Color(0, 0, 0, 1)
const Connection = preload("res://Generator/Connection/Connection.gd")
const ICONS_PER_ROW = 8

const GRID_CELL_SIZE = 16
const DOOR_DRAW_RADIUS = 4

func get_minimap():
    return get_node("../..")

func get_room():
    return get_minimap().get_room()

func _draw() -> void:
    var minimap = get_minimap()
    var grid = minimap._grid
    var dims = minimap._dims
    var boxes = minimap._boxes
    var discovered = minimap._discovered
    var connections = minimap._connections
    var icons = minimap._icons

    if grid == null:
        return
    var upperleft = Vector2(get_viewport_rect().size.x - GRID_CELL_SIZE * dims.x, 0)
    var playerpos = minimap._find_player()
    var playerrpos = playerpos / GeneratorData.TOTAL_CELL_SIZE
    playerrpos.x = floor(playerrpos.x)
    playerrpos.y = floor(playerrpos.y)
    var playerroom = grid.get_value(playerrpos)
    discovered[playerroom] = true

    # Background
    for i in range(dims.x):
        for j in range(dims.y):
            var cell = grid.get_value(Vector2(i, j))
            if discovered.has(cell):
                var color = COLOR_ROOM
                if cell == playerroom:
                    color = COLOR_CURRENT_ROOM
                draw_rect(Rect2(upperleft + Vector2(i, j) * GRID_CELL_SIZE, Vector2(1, 1) * GRID_CELL_SIZE), color, true)

    # Room barriers
    for v in boxes.values():
        if not discovered.has(v.id):
            continue
        if v is GeneratorData.HallwayData:
            for point in v.data:
                var cellpos = point * GRID_CELL_SIZE + upperleft
                # Up
                if grid.get_value(point + Vector2(0, -1)) != v.id:
                    draw_line(cellpos, cellpos + Vector2(GRID_CELL_SIZE, 0), COLOR_BOUNDARY)
                # Left
                if grid.get_value(point + Vector2(-1, 0)) != v.id:
                    draw_line(cellpos, cellpos + Vector2(0, GRID_CELL_SIZE), COLOR_BOUNDARY)
                # Down
                if grid.get_value(point + Vector2(0, 1)) != v.id:
                    draw_line(cellpos + Vector2(0, GRID_CELL_SIZE), cellpos + Vector2(GRID_CELL_SIZE, GRID_CELL_SIZE), COLOR_BOUNDARY)
                # Right
                if grid.get_value(point + Vector2(1, 0)) != v.id:
                    draw_line(cellpos + Vector2(GRID_CELL_SIZE, 0), cellpos + Vector2(GRID_CELL_SIZE, GRID_CELL_SIZE), COLOR_BOUNDARY)
        elif v is GeneratorData.RoomData:
            var rect = v.box
            rect = Rect2(rect.position * GRID_CELL_SIZE + upperleft, rect.size * GRID_CELL_SIZE)
            draw_rect(rect, COLOR_BOUNDARY, false)

    # Doors
    for c in connections:
        var pos0 = c.get_pos0()
        var pos1 = c.get_pos1()
        var a = grid.get_value(pos0)
        var b = grid.get_value(pos1)
        if discovered.has(a) or discovered.has(b):
            var cellpos = pos0 * GRID_CELL_SIZE + upperleft
            var center = Vector2(-128, -128) # Off-screen to start with, just in case
            if (pos1 - pos0) == Vector2(1, 0):
                # warning-ignore: integer_division
                center = cellpos + Vector2(GRID_CELL_SIZE, GRID_CELL_SIZE / 2)
            elif (pos1 - pos0) == Vector2(0, 1):
                # warning-ignore: integer_division
                center = cellpos + Vector2(GRID_CELL_SIZE / 2, GRID_CELL_SIZE)
            var rect = Rect2(center - Vector2(DOOR_DRAW_RADIUS, DOOR_DRAW_RADIUS),
                             Vector2(DOOR_DRAW_RADIUS, DOOR_DRAW_RADIUS) * 2)
            match c.get_lock():
                Connection.LockType.NONE, Connection.LockType.SIMPLE_LOCK:
                    draw_rect(rect, COLOR_BOUNDARY, true)

    # Icons
    for v in boxes.values():
        if not discovered.has(v.id):
            continue
        if v is GeneratorData.RoomData:
            if not (v.id in icons):
                continue
            var curr_icons = icons[v.id]
            var rect = v.box
            var screen_rect = Rect2(rect.position * GRID_CELL_SIZE + upperleft, rect.size * GRID_CELL_SIZE)
            # warning-ignore: integer_division
            var draw_pos = screen_rect.position + screen_rect.size / 2
            draw_pos -= (Vector2(6, 0) if len(curr_icons) == 1 else Vector2(12, 0))
            draw_pos -= Vector2(0, 6) * ceil((len(curr_icons) + 1) / 2)
            var offset = Vector2()
            for ico in curr_icons:
                var coords = 12 * Vector2(ico % ICONS_PER_ROW, floor(ico / ICONS_PER_ROW))
                draw_texture_rect_region(Icons.Image,
                                         Rect2(draw_pos + offset, Vector2(12, 12)),
                                         Rect2(coords, Vector2(12, 12)),
                                         Color(1, 1, 1, 0.25))
                if offset.x > 0:
                    offset.x = 0
                    offset.y += 12
                else:
                    offset.x += 12
