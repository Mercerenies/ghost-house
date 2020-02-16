extends Node2D

func set_status(status: StatusInstance) -> void:
    var effect = status.get_effect()

    var text = effect.get_name()
    if status.get_length() >= 0:
        # warning-ignore: integer_division
        var time_display = "%d:%02d" % [status.get_length() / 60, status.get_length() % 60]
        text += "\n" + time_display

    $Sprite.frame = effect.get_icon_index()
    $Label.set_text(text)
