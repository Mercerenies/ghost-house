extends Node2D

const INDEX_LEFT        = 0
const INDEX_RIGHT       = 1
const INDEX_LEFT_FRONT  = 4
const INDEX_RIGHT_FRONT = 5
const INDEX_TOP         = 2
const INDEX_BOTTOM      = 3

func _draw() -> void:
    var sink = get_parent()
    var room = sink.get_room()
    var pos = sink.cell
    var image = FurnitureShim.Image
    var frame = get_node("../Sprite").frame
    match sink.get_shim_channel():
        sink.ShimChannel.KitchenCounterNS:
            var above = room.get_entity_cell(pos + Vector2(0, -1))
            var below = room.get_entity_cell(pos + Vector2(0, 2))
            if above is Furniture and above.get_shim_channel() == sink.ShimChannel.KitchenCounterNS:
                draw_texture_rect_region(image,
                                         Rect2(0, 0, 32, 32),
                                         FurnitureShim.index_to_rect(INDEX_TOP))
            if below is Furniture and below.get_shim_channel() == sink.ShimChannel.KitchenCounterNS:
                draw_texture_rect_region(image,
                                         Rect2(0, 32, 32, 32),
                                         FurnitureShim.index_to_rect(INDEX_BOTTOM))
        sink.ShimChannel.KitchenCounterWE:
            var left = room.get_entity_cell(pos + Vector2(-1, 0))
            var right = room.get_entity_cell(pos + Vector2(2, 0))
            if left is Furniture and left.get_shim_channel() == sink.ShimChannel.KitchenCounterWE:
                draw_texture_rect_region(image,
                                         Rect2(0, 0, 32, 32),
                                         FurnitureShim.index_to_rect(INDEX_LEFT_FRONT if frame == 0 else INDEX_LEFT))
            if right is Furniture and right.get_shim_channel() == sink.ShimChannel.KitchenCounterWE:
                draw_texture_rect_region(image,
                                         Rect2(32, 0, 32, 32),
                                         FurnitureShim.index_to_rect(INDEX_RIGHT_FRONT if frame == 0 else INDEX_RIGHT))
