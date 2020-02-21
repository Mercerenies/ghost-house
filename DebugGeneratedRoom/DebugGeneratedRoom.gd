extends Node2D

const Generator = preload("res://Generator/Generator.gd")

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
    var DebugItem = ItemCodex.get_item_script(ItemCodex.ID_DebugItem)
    var inv = room.get_player_stats().get_inventory()
    for i in range(20):
        inv.add_item(ItemInstance.new(DebugItem.new(), null))
