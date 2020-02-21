extends Node
class_name ItemCodex

const ID_DebugItem = 1

static func get_item_script(id: int) -> Script:
    match id:
        ID_DebugItem:
            return load("res://Item/DebugItem.gd") as Script

static func get_item(id: int) -> Item:
    return get_item_script(id).new()
