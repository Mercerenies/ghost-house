extends Node
class_name ItemCodex

const ID_DebugItem = 1
const ID_Potion = 2

static func get_item_script(id: int) -> Script:
    match id:
        ID_DebugItem:
            return load("res://Item/DebugItem.gd") as Script
        ID_Potion:
            return load("res://Item/Potion.gd") as Script

static func get_item(id: int) -> Item:
    return get_item_script(id).new()
