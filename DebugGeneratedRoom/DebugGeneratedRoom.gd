extends Node2D

const Generator = preload("res://Generator/Generator.gd")

func _ready():
    randomize()
    var gen = Generator.new({ 'config': { 'width': 12, 'height': 12, "percent_evil": 0.05 } })
    var room = gen.generate()
    add_child(room)
