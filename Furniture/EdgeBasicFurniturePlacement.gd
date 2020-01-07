extends EdgeFurniturePlacement
class_name EdgeBasicFurniturePlacement

var _scene: PackedScene
var _width: int

func _init(scene: PackedScene, width: int):
    _scene = scene
    _width = width

func get_scene() -> PackedScene:
    return _scene

func get_width() -> int:
    return _width

func spawn_at(position: Vector2, direction: int):
    var obj = _scene.instance()
    obj.position = position * 32
    obj.set_direction(direction)
    return obj
