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

func _process(_delta: float) -> void:
    if visible:
        if Input.is_action_just_released("ui_accept"):
            if $Label.text == _text:
                $Label.text = ""
                _text = ""
                visible = false
            else:
                $Label.text = _text