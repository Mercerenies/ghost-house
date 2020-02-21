extends Reference
class_name ItemInstance

var _item: Item
var _metadata

# metadata can be any arbitrary metadata, provided the data is
# JSON-friendly, i.e. arrays, dictionaries, strings, numbers, bools,
# and null.
func _init(item: Item, metadata) -> void:
    _item = item
    _metadata = metadata

func get_item() -> Item:
    return _item

func get_metadata():
    return _metadata
