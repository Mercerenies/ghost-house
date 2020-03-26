extends Reference

###################################
# STAGE 4 - CONNECTION GENERATION #
###################################

const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const Connection = preload("res://Generator/Connection/Connection.gd")
const Graph = preload("res://Generator/Graph/Graph.gd")

const ID_HALLS = GeneratorData.ID_HALLS

var _data: Dictionary = {}
var _grid: GeneratorGrid = null

func _init(room_data: Dictionary, grid: GeneratorGrid):
    _data = room_data
    _grid = grid

func _produce_adjacency_graph() -> Graph:
    var w = int(_data['config']['width'])
    var h = int(_data['config']['height'])
    var graph = Graph.new()
    var adja = graph.adja
    for x in range(w):
        for y in range(h):
            var a = _grid.get_value(Vector2(x, y))
            var b = _grid.get_value(Vector2(x + 1, y))
            var c = _grid.get_value(Vector2(x, y + 1))
            if a >= ID_HALLS and not adja.has(a):
                adja[a] = []
            if b >= ID_HALLS and not adja.has(b):
                adja[b] = []
            if c >= ID_HALLS and not adja.has(c):
                adja[c] = []
            if a >= ID_HALLS and b >= ID_HALLS and a != b:
                var link = [Vector2(x, y), Vector2(x + 1, y)]
                adja[a].append(Connection.new(link, b))
                adja[b].append(Connection.new(link, a))
            if a >= ID_HALLS and c >= ID_HALLS and a != c:
                var link = [Vector2(x, y), Vector2(x, y + 1)]
                adja[a].append(Connection.new(link, c))
                adja[c].append(Connection.new(link, a))
    return graph

func _connect_rooms() -> Array:
    var connections = []
    var graph = _produce_adjacency_graph()
    var total_nodes = len(graph.adja.keys())
    var visited = [_grid.get_value(Vector2(0, 0))]
    var edges = []
    for es in graph.adja.values():
        for e in es:
            edges.append(e)
    edges.shuffle()
    var edge_count = len(edges)
    while len(visited) < total_nodes:
        var i = 0
        while i < edge_count:
            var edge = edges[i]
            var a = _grid.get_value(edge.get_pos0())
            var b = _grid.get_value(edge.get_pos1())
            if visited.has(a) != visited.has(b):
                connections.append(edge)
                if not visited.has(a):
                    visited.append(a)
                if not visited.has(b):
                    visited.append(b)
                edge_count -= 1
                edges[i] = edges[edge_count]
                edges[edge_count] = edge
            else:
                i += 1
    for i in range(edge_count):
        # Add 5% of the extras back
        var edge = edges[i]
        if randf() < 0.05:
            connections.append(edge)
    return connections

func run() -> Array:
    return _connect_rooms()
