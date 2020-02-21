extends Node2D

const INDEX_LEFT   = 0
const INDEX_RIGHT  = 1
const INDEX_TOP    = 2
const INDEX_BOTTOM = 3

func _draw() -> void:
    var dishwasher = get_parent()
    var room = dishwasher.get_room()
    var pos = dishwasher.cell
    var image = FurnitureShim.Image
    match dishwasher.get_shim_channel():
        dishwasher.ShimChannel.KitchenCounterNS:
            var above = room.get_entity_cell(pos + Vector2(0, -1))
            var below = room.get_entity_cell(pos + Vector2(0, 1))
            if above is Furniture and above.get_shim_channel() == dishwasher.ShimChannel.KitchenCounterNS:
                draw_texture_rect_region(image,
                                         Rect2(0, 0, 32, 32),
                                         FurnitureShim.index_to_rect(INDEX_TOP))
            if below is Furniture and below.get_shim_channel() == dishwasher.ShimChannel.KitchenCounterNS:
                draw_texture_rect_region(image,
                                         Rect2(0, 0, 32, 32),
                                         FurnitureShim.index_to_rect(INDEX_BOTTOM))
        dishwasher.ShimChannel.KitchenCounterWE:
            var left = room.get_entity_cell(pos + Vector2(-1, 0))
            var right = room.get_entity_cell(pos + Vector2(1, 0))
            if left is Furniture and left.get_shim_channel() == dishwasher.ShimChannel.KitchenCounterWE:
                draw_texture_rect_region(image,
                                         Rect2(0, 0, 32, 32),
                                         FurnitureShim.index_to_rect(INDEX_LEFT))
            if right is Furniture and right.get_shim_channel() == dishwasher.ShimChannel.KitchenCounterWE:
                draw_texture_rect_region(image,
                                         Rect2(0, 0, 32, 32),
                                         FurnitureShim.index_to_rect(INDEX_RIGHT))
