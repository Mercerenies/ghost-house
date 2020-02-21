extends Node2D

const Generator = preload("res://Generator/Generator.gd")

const DebugItem = preload("res://Item/DebugItem.gd") # DEBUG CODE

func _ready():
    randomize()

    var data = {}
    var file = File.new()
    file.open("res://DebugGeneratedRoom/test1.json", File.READ)
    var result = JSON.parse(file.get_as_text())
    if result.error == OK:
        data = result.result

    var gen = Generator.new(data)
    var room = gen.generate()
    add_child(room)

    # DEBUG CODE
    var inv = room.get_player_stats().get_inventory()
    for i in range(20):
        inv.add_item(ItemInstance.new(DebugItem.new(), null))
