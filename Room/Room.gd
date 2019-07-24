extends TileMap
class_name Room

const Tile = RoomTypes.Tile

var entities: Dictionary = {}

func get_tile_cell(pos: Vector2) -> int:
    var result = get_cellv(pos)
    return Tile.EmptyTile if result < 0 else result

func set_tile_cell(pos: Vector2, val: int) -> void:
    set_cellv(pos, val)

func get_entity_cell(pos: Vector2) -> Object:
    if entities.has(pos):
        return entities[pos]
    else:
        return null

func set_entity_cell(pos: Vector2, val: Object) -> void:
    entities[pos] = val

func move_entity(src: Vector2, dest: Vector2) -> void:
    set_entity_cell(dest, get_entity_cell(src))
    set_entity_cell(src, null)

func is_wall_at(pos: Vector2) -> bool:
    return RoomTypes.walls.has(get_tile_cell(pos))

func is_showing_modal() -> bool:
    return get_dialogue_box().is_active()

func show_dialogue(dia: Dictionary) -> void:
    get_dialogue_box().popup(dia)

func get_dialogue_box():
    return $CanvasLayer/DialogueBox

func get_minimap():
    return $CanvasLayer/Minimap

func get_entities() -> Array:
    # Remember, this also returns the CanvasLayer...
    return get_children()

func _ready():
    pass
