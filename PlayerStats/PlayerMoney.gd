extends Node2D

export var money: int = 0

func _ready() -> void:
    _update_label()

func _update_label() -> void:
    # warning-ignore: narrowing_conversion
    var label_money: int = min(money, 9999999)
    var display_text = ""
    while label_money != 0:
        display_text = "," + str(label_money % 1000) + display_text
        # warning-ignore: integer_division
        label_money = int(label_money / 1000)
    if display_text == "":
        display_text = ",0"
    $Label.set_text( display_text.substr(1, len(display_text)) )

func get_money() -> int:
    return money

func set_money(a: int) -> void:
    money = int(max(a, 0))
    _update_label()
