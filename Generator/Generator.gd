extends Node
class_name Generator

const RoomScene = preload("res://Room/Room.tscn")
const PlayerScene = preload("res://Player/Player.tscn")

var _data: Dictionary = {}
var _room: Room = null

func _init(room_data: Dictionary):
    _data = room_data

func _add_entity(pos: Vector2, entity: Object) -> void:
    _room.add_child(entity)
    entity.position = pos * 32
    _room.set_entity_cell(pos, entity)

func generate() -> Room:
    _room = RoomScene.instance()
    for i in range(_data['config']['width']):
        for j in range(_data['config']['height']):
            _room.set_tile_cell(Vector2(i, j), _room.Tile.DebugFloor)
    var player = PlayerScene.instance()
    _add_entity(Vector2(randi() % _data['config']['width'], randi() % _data['config']['height']), player)
    return _room
