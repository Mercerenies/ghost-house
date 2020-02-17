extends Reference
class_name ItemInstance

var _item: Item

func _init(item: Item) -> void:
    _item = item

func get_item() -> Item:
    return _item
