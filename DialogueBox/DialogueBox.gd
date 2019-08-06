extends Node2D

var _data: Dictionary = {}
var _state: String = "start"
var _index: int = 0
var _text: String = ""
var _vars: Dictionary = {}
var _active_branch: Array = []

func _ready():
    _data = {}
    _end_conversation_now()

func is_active() -> bool:
    return not _data.empty()

func popup(data: Dictionary, state: String = "start", vars: Dictionary = {}) -> void:
    _end_conversation_now()
    _data = data
    _index = -1
    _state = state
    _vars = vars
    _advance_state()

func _end_conversation() -> void:
    _end_conversation_now()
    call_deferred("_end_conversation_deferred")

func _end_conversation_now() -> void:
    visible = false
    _text = ""
    _active_branch = []
    $Label.text = ""
    $SpeakerLabel.text = ""
    $SpeakerFrame.visible = false
    $Branching.visible = false
    _state = "start"
    _index = 0
    _vars = {}
    $ShowTimer.stop()

func _end_conversation_deferred() -> void:
    _data = {}

func _advance_state() -> void:
    _index += 1
    _text = ""
    _active_branch = []
    $Label.text = ""
    $SpeakerLabel.text = ""
    $SpeakerFrame.visible = false
    $Branching.visible = false
    $ShowTimer.stop()
    visible = false
    if _index >= len(_data[_state]):
        _end_conversation()
    else:
        var instr = _data[_state][_index]
        match instr['command']:
            'say':
                _text = instr['text']
                if instr.has('speaker'):
                    $SpeakerFrame.visible = true
                    $SpeakerLabel.text = instr['speaker']
                $ShowTimer.start()
                visible = true
            'goto':
                _state = instr['target']
                _index = -1
                _advance_state()
            'end':
                _end_conversation()
            'branch':
                _text = instr['text']
                if instr.has('speaker'):
                    $SpeakerFrame.visible = true
                    $SpeakerLabel.text = instr['speaker']
                $ShowTimer.start()
                visible = true
                _active_branch = instr['options']

func _text_shown() -> void:
    if not _active_branch.empty():
        $Branching.popup(_active_branch)

func _on_ShowTimer_timeout() -> void:
    if $Label.text != _text:
        $Label.text = _text.substr(0, $Label.text.length() + 1)
        if $Label.text == _text:
            _text_shown()

func _process(_delta: float) -> void:
    if is_active():
        if Input.is_action_just_released("ui_accept"):
            if $Label.text == _text and _text != "":
                if $Branching.is_active():
                    var opt = $Branching.get_chosen_option()
                    _state = opt['state']
                    _index = -1
                    $Branching.hide()
                _advance_state()
            else:
                $Label.text = _text
                if $Label.text == _text:
                    _text_shown()
