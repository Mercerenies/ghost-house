extends Reference

#
# STAGE 1 - HALLWAY GENERATION
#

const HallwayData = GeneratorData.HallwayData

const GeneratorGrid = preload("res://GeneratorGrid/GeneratorGrid.gd")

var _data: Dictionary = {}
var _grid: GeneratorGrid = null
var _boxes: Dictionary = {}

func _init(room_data: Dictionary, grid: GeneratorGrid, boxes: Dictionary):
    _data = room_data
    _grid = grid
    _boxes = boxes

func _produce_hallway_attempt():
    var w = _data['config']['width']
    var h = _data['config']['height']
    var hall_length = Util.randi_range(4, min(w, h))
    var arr = []
    var startx = randi() % w
    var starty = randi() % h
    var x = startx
    var y = starty
    var dir = Util.random_dir()
    for _i in range(hall_length):
        if x < 2 or x >= w - 2 or y < 2 or y >= h - 2:
            return null # Out of bounds failure!
        arr.append(Vector2(x, y))
        if randf() < 0.10:
            dir = Util.random_dir()
        x += dir.x
        y += dir.y
    return arr

func _produce_hallway():
    for _attempt in range(20): # Try 20 times, then give up
        var hw = _produce_hallway_attempt()
        if hw != null:
            return hw
    return null

func _merge_hallways(hws: Array) -> Array:
    var cache = {}
    var accepted = hws.duplicate()
    for hw in hws:
        for pos in hw.data:
            if cache.has(pos):
                # Merge: change every old_id into new_id
                var old_id = cache[pos].id
                var new_id = hw.id
                #print("Merging {} into {}".format([old_id, new_id], "{}"))
                for hwc in hws:
                    if hwc.id == old_id:
                        hwc.id = new_id
                        for v in hwc.data:
                            if not hw.data.has(v):
                                hw.data.append(v)
                            var f = accepted.find(hwc)
                            if f:
                                accepted.remove(f)
            else:
                cache[pos] = hw
    return accepted

func _produce_hallways(start_id: int) -> Array:
    var hws = []
    for i in range(start_id, start_id + 3):
        var hw = _produce_hallway()
        if hw != null:
            hws.append(HallwayData.new(i, hw))
    # It is always possible that the hallways generated overlapping one another. It's fine
    # if they did, but in that case we need to make sure the two overlapping hallways have
    # the same ID value. _merge_hallways ensures this by modifying the array.
    return _merge_hallways(hws)

func _paint_hallway(hw: HallwayData) -> void:
    for pos in hw.data:
        _grid.set_value(pos, hw.id)
    _boxes[hw.id] = hw

func run(start_id: int) -> void:
    var hws =  _produce_hallways(start_id)
    for hw in hws:
        _paint_hallway(hw)
