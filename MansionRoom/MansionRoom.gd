extends Node2D

const Generator = preload("res://Generator/Generator.gd")

var _data: JSONData.Data

func _init(data: JSONData.Data):
    _data = data

func _ready() -> void:
    var mansion_data = _data.load_data()
    var gen = Generator.new(mansion_data)
    var room = gen.generate()
    add_child(room)
