extends Node2D

const INDEX_LEFT   = 0
const INDEX_RIGHT  = 1
const INDEX_TOP_R  = 6
const INDEX_TOP_L  = 7
const INDEX_BOTTOM = 3

func _draw() -> void:
    var stove = get_parent()
    var room = stove.get_room()
    var pos = stove.cell
    var image = FurnitureShim.Image
    var frame = get_node("../Sprite").frame
    match stove.get_shim_channel():
        stove.ShimChannel.KitchenCounterNS:
            var above = room.get_entity_cell(pos + Vector2(0, -1))
            var below = room.get_entity_cell(pos + Vector2(0, 1))
            if above is Furniture and above.get_shim_channel() == stove.ShimChannel.KitchenCounterNS:
                draw_texture_rect_region(image,
                                         Rect2(0, 0, 32, 32),
                                         FurnitureShim.index_to_rect(INDEX_TOP_L if frame == 3 else INDEX_TOP_R))
            if below is Furniture and below.get_shim_channel() == stove.ShimChannel.KitchenCounterNS:
                draw_texture_rect_region(image,
                                         Rect2(0, 0, 32, 32),
                                         FurnitureShim.index_to_rect(INDEX_BOTTOM))
        stove.ShimChannel.KitchenCounterWE:
            var left = room.get_entity_cell(pos + Vector2(-1, 0))
            var right = room.get_entity_cell(pos + Vector2(1, 0))
            if left is Furniture and left.get_shim_channel() == stove.ShimChannel.KitchenCounterWE:
                draw_texture_rect_region(image,
                                         Rect2(0, 0, 32, 32),
                                         FurnitureShim.index_to_rect(INDEX_LEFT))
            if right is Furniture and right.get_shim_channel() == stove.ShimChannel.KitchenCounterWE:
                draw_texture_rect_region(image,
                                         Rect2(0, 0, 32, 32),
                                         FurnitureShim.index_to_rect(INDEX_RIGHT))
