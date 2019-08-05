extends EdgeFurniturePlacement

const TorchScene = preload("Torch.tscn")

func get_width() -> int:
    return 1

func spawn_at(position: Vector2, direction: int):
    var obj = TorchScene.instance()
    obj.position = position * 32
    obj.set_direction(direction)
    return obj
