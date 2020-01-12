extends Node
class_name SpecialPlacement

# TODO Make UniformDistr and WeightedDistr return managers themselves
# so they can be composed with other managers.

class UniformDistr extends SpecialPlacementManager:
    var _values: Array

    func _init(values: Array) -> void:
        _values = values

    func determine_placements(_size: Vector2) -> Array:
        return _values[randi() % len(_values)]

# Expects each entry to be { "result": result, "weight": weight }.
# Weights should be nonnegative integers.
class WeightedDistr extends SpecialPlacementManager:
    var _values: Array

    func _init(values: Array) -> void:
        _values = values

    func determine_placements(_size: Vector2) -> Array:
        var total = 0
        for v in _values:
            total += v["weight"]
        var choice = randi() % int(total)
        for v in _values:
            choice -= v["weight"]
            if choice < 0:
                return v["result"]
        return [] # This shouldn't happen

class Trivial extends SpecialPlacementManager:
    var _values: Array

    func _init(values: Array) -> void:
        _values = values

    func determine_placements(_size: Vector2) -> Array:
        return _values

class Nothing extends SpecialPlacementManager:

    func determine_placements(_size: Vector2) -> Array:
        return []
