extends Node2D

var _text: String = ""

func _ready():
    $Label.text = ""

func popup_text(text: String) -> void:
    _text = text
    $Label.text = ""
    $ShowTimer.start()
    visible = true

func _on_ShowTimer_timeout():
    $Label.text = _text.substr(0, $Label.text.length() + 1)
