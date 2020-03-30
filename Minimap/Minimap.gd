extends Node2D

const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const Player = preload("res://Player/Player.gd")
const Connection = preload("res://Generator/Connection/Connection.gd")

var _dims: Vector2 = Vector2(0, 0)
var _grid: GeneratorGrid = null
var _boxes: Dictionary = {}
var _connections: Array = []
var _discovered: Dictionary = {}
var _icons: Dictionary = {}

# So The minimap draws in three stages: Background, Eraser,
# Foreground. This is to simulate the OpenGL REPLACE blend mode, which
# Godot unfortunately doesn't expose. The first stage draws the back
# layer, the second erases a mask for the third stage, and the third
# draws back at the masked positions.

func _ready():
    pass

func initialize(dims: Vector2, grid: GeneratorGrid, boxes: Dictionary, connections: Array) -> void:
    _dims = dims
    _grid = grid
    _boxes = boxes
    _connections = connections
    _discovered = {}
    update_map()

func is_initialized() -> bool:
    # Any number of these instance variables would suffice. This one
    # is just easy to check.
    return _dims.x > 0

func get_room():
    return get_node("../..")

func get_room_id_at_pos(pos: Vector2):
    if not is_initialized():
        return null
    return _grid.get_value(pos)

func update_map() -> void:
    $Viewport/Background.update()
    $Viewport/Eraser.update()
    $Viewport/Foreground.update()

func discover_room(id: int) -> void:
    _discovered[id] = true
    update_map()

func room_ids() -> Array:
    return _boxes.keys()

func add_icon(room_id: int, icon_id: int) -> void:
    if not (room_id in _icons):
        _icons[room_id] = []
    _icons[room_id].append(icon_id)
    update_map()

# Removes one copy of the icon from the room. No action if the icon
# does not appear on the room.
func remove_icon(room_id: int, icon_id: int) -> void:
    _icons[room_id].erase(icon_id)
    update_map()

func clear_icons(room_id: int) -> void:
    if room_id in _icons:
        _icons[room_id] = []
    update_map()

func get_icons(room_id: int) -> Array:
    if room_id in _icons:
        return _icons[room_id]
    return []

func get_connections_list() -> Array:
    return _connections

func unlock_doorway(ref: WeakRef) -> void:
    var conn = ref.get_ref()
    if conn:
        conn.set_lock(Connection.LockType.NONE)
        update_map()

func _find_player() -> Vector2:
    var room = get_room()
    # First, check marked entities (more efficient)
    var marks = room.get_marked_entities()
    if Mark.PLAYER in marks:
        return marks[Mark.PLAYER].cell
    # If not, fall back to the less efficient linear search
    for c in room.get_entities():
        if c is Player:
            return c.cell
    # Can't find the player
    return Vector2(-1, -1)

func _on_Player_player_moved(_speed: float) -> void:
    update_map()
