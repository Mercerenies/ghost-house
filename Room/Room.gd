extends TileMap
class_name Room

const Tile = RoomTypes.Tile
const FurnitureDropScene = preload("res://FurnitureDrop/FurnitureDrop.tscn")

var entities: Dictionary = {}
var marked_entities: Dictionary = {}

func is_in_bounds(pos: Vector2) -> bool:
    return (get_cellv(pos) >= 0)

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

func show_dialogue(dia: Dictionary, state: String = "start", vars: Dictionary = {}) -> void:
    get_dialogue_box().popup(dia, state, vars)

func get_dialogue_box():
    return $CanvasLayer/DialogueBox

func get_minimap():
    return $CanvasLayer/Minimap

func get_player_stats():
    return $CanvasLayer/PlayerStats

func get_pause_menu():
    return $CanvasLayer/PauseMenu

func get_ghost_database():
    return $Info/GhostDatabase

func get_entities() -> Array:
    return $Entities.get_children()

func get_marked_entities() -> Dictionary:
    return marked_entities

func _ready():
    pass

func _on_DialogueBox_do_action(action, arg):
    match action:
        "noop":
            pass
        "harm_player":
            get_player_stats().damage_player(arg)
        "furniture_drop":
            var scene = FurnitureDropScene.instance()
            scene.assign_sprite(arg)
            $CanvasLayer.add_child(scene)
