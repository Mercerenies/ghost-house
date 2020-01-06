extends Node2D

const Generator = preload("res://Generator/Generator.gd")

func _ready():
    randomize()
	# DEBUG CODE (should be 0.05 percent_evil)
    var gen = Generator.new({ 'config': { 'width': 12, 'height': 12, "percent_evil": 0.50 } })
    var room = gen.generate()
    add_child(room)
