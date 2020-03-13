extends FurnitureInteraction

const FurnitureDustCloud = preload("FurnitureDustCloud.tscn")

var furniture

func _init(furniture) -> void:
    self.furniture = furniture

func perform_interaction() -> void:

    var size: Vector2 = furniture.get_dims()

    var cloud = FurnitureDustCloud.instance()
    cloud.position = (size * 32) / 2
    cloud.emission_rect_extents = (size * 32) / 2
    furniture.add_child(cloud)
