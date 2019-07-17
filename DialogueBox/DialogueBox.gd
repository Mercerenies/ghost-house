extends Node2D

var _data: Dictionary = {}
var _state: String = "start"
var _index: int = 0
var _text: String = ""

func _ready():
    $Label.text = ""

func is_active() -> bool:
    return not _data.empty()

func popup(data: Dictionary, state: String = "start") -> void:
    _data = data
    _state = state
    _index = -1
    _text = ""
    $Label.text = ""
    _advance_state()

func _end_conversation() -> void:
    visible = false
    _text = ""
    $Label.text = ""
    _state = "start"
    _data = {}
    $ShowTimer.stop()

func _advance_state() -> void:
    _index += 1
    _text = ""
    $Label.text = ""
    $ShowTimer.stop()
    if _index >= len(_data[_state]):
        _end_conversation()
    else:
        var instr = _data[_state][_index]
        match instr['command']:
            'say':
                _text = instr['text']
                $ShowTimer.start()
                visible = true
            'goto':
                _state = instr['target']
                _index = -1
                _advance_state()
            'end':
                _end_conversation()

func _on_ShowTimer_timeout():
    $Label.text = _text.substr(0, $Label.text.length() + 1)

func _process(_delta: float) -> void:
    if visible:
        if Input.is_action_just_released("ui_accept"):
            if $Label.text == _text:
                _advance_state()
            else:
                $Label.text = _text
