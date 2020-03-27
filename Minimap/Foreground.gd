extends Node2D

const COLOR_ROOM = Color(1, 1, 1, 0.5)
const COLOR_CURRENT_ROOM = Color(1, 0, 0, 0.5)
const COLOR_BOUNDARY = Color(0, 0, 0, 1)
const Connection = preload("res://Generator/Connection/Connection.gd")

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
    #var boxes = minimap._boxes
    var discovered = minimap._discovered
    var connections = minimap._connections
    #var icons = minimap._icons

    if grid == null:
        return
    var upperleft = Vector2(get_viewport_rect().size.x - GRID_CELL_SIZE * dims.x, 0)

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
                Connection.LockType.SIMPLE_LOCK:
                    draw_rect(rect, COLOR_ROOM, true)
                    draw_rect(rect, COLOR_BOUNDARY, false)
