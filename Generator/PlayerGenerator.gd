extends Reference

###############################
# STAGE 9 - PLAYER GENERATION #
###############################

const GeneratorGrid = preload("res://GeneratorGrid/GeneratorGrid.gd")
const GeneratorPlacementHelper = preload("res://GeneratorPlacementHelper/GeneratorPlacementHelper.gd")

const Player = preload("res://Player/Player.tscn")

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData

const FLAG_EDGE_FURNITURE = GeneratorData.FLAG_EDGE_FURNITURE

const CELL_SIZE = GeneratorData.CELL_SIZE
const WALL_SIZE = GeneratorData.WALL_SIZE
const TOTAL_CELL_SIZE = GeneratorData.TOTAL_CELL_SIZE

var _data: Dictionary = {}
var _grid: GeneratorGrid = null
var _boxes: Dictionary = {}
var _room: Room
var _helper: GeneratorPlacementHelper

func _init(room_data: Dictionary,
           grid: GeneratorGrid,
           boxes: Dictionary,
           room: Room,
           helper: GeneratorPlacementHelper):
    _data = room_data
    _grid = grid
    _boxes = boxes
    _room = room
    _helper = helper

func _identify_valid_rect() -> Rect2:
    # warning-ignore: integer_division
    var target_pos = Vector2(_grid.get_width() / 2, _grid.get_height() - 1)
    var room_id = _grid.get_value(target_pos)
    var room = _boxes[room_id]
    if room is HallwayData:
        return Rect2(target_pos * TOTAL_CELL_SIZE + Vector2(1, 1) * WALL_SIZE,
                     Vector2(CELL_SIZE, CELL_SIZE))
    return Rect2(room.box.position * TOTAL_CELL_SIZE + Vector2(1, 1) * WALL_SIZE,
                 room.box.size * TOTAL_CELL_SIZE - 2 * WALL_SIZE * Vector2(1, 1))

func put_player_in(valid_rect: Rect2):
    var valid_positions = []
    var player = Player.instance()
    for i in range(valid_rect.position.x, valid_rect.end.x):
        for j in range(valid_rect.position.y, valid_rect.end.y):
            if _room.get_entity_cell(Vector2(i, j)) == null and not _room.is_wall_at(Vector2(i, j)):
                valid_positions.append(Vector2(i, j))
    var pos = Util.choose(valid_positions)
    _helper.add_entity(pos, player)
    return player

func run():
    var rect = _identify_valid_rect()
    var player = put_player_in(rect)
    player.connect("player_moved", _room.get_minimap(), "update_map")
    return player
