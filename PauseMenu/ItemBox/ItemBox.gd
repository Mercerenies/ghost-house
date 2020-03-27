extends Node2D

func set_item(item: ItemInstance) -> void:
    var text = item.get_name()
    $ItemSprite.frame = item.get_icon_index()
    $Label.set_text(text)
