extends Node2D

func set_item(item: ItemInstance) -> void:
    var data = item.get_item()
    var text = data.get_name()

    $Sprite.frame = data.get_icon_index()
    $Label.set_text(text)
