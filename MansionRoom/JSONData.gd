class_name JSONData
extends Node

class Data:
    func load_data():
        pass

class ConstantData extends Data:
    var _data

    func _init(data):
        _data = data

    func load_data():
        return _data

class FileData extends Data:
    var _filename
    var _data

    func _init(filename):
        _filename = filename
        _data = null

    func load_data():
        if _data == null:
            var file = File.new()
            file.open(_filename, File.READ)
            var result = JSON.parse(file.get_as_text())
            file.close()
            assert(result.error == OK)
            _data = result.result
        return _data

static func wrap(obj):
    if obj is Dictionary:
        return ConstantData.new(obj)
    if obj is String:
        return FileData.new(obj)
    assert(obj is Data)
    return obj
