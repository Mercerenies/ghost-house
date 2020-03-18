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

func get_id() -> int:
    return _item.get_id(self)

func get_name() -> String:
    return _item.get_name(self)

func get_description() -> String:
    return _item.get_description(self)

func get_icon_index() -> int:
    return _item.get_icon_index(self)

func get_tags() -> Array:
    return _item.get_tags(self)

func get_actions() -> Array:
    return _item.get_actions(self)

func copy():
    return get_script().new(_item, Util.deep_copy(_metadata))
