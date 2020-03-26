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

class _Incidence:
    var _grid

    func _init(grid) -> void:
        _grid = grid

    func incidence(edge) -> Array:
        return [_grid.get_value(edge.get_pos0()), _grid.get_value(edge.get_pos1())]

func _init(room_data: Dictionary, grid: GeneratorGrid):
    _data = room_data
    _grid = grid

func _produce_adjacency_graph() -> Graph:
    var w = int(_data['config']['width'])
    var h = int(_data['config']['height'])
    var graph = Graph.new([], _Incidence.new(_grid))
    for x in range(w):
        for y in range(h):
            var a = _grid.get_value(Vector2(x, y))
            var b = _grid.get_value(Vector2(x + 1, y))
            var c = _grid.get_value(Vector2(x, y + 1))
            if a >= ID_HALLS and not graph.has_vertex(a):
                graph.add_vertex(a)
            if b >= ID_HALLS and not graph.has_vertex(b):
                graph.add_vertex(b)
            if c >= ID_HALLS and not graph.has_vertex(c):
                graph.add_vertex(c)
            if a >= ID_HALLS and b >= ID_HALLS and a != b:
                var link = [Vector2(x, y), Vector2(x + 1, y)]
                var conn = Connection.new(link)
                graph.add_edge(conn)
            if a >= ID_HALLS and c >= ID_HALLS and a != c:
                var link = [Vector2(x, y), Vector2(x, y + 1)]
                var conn = Connection.new(link)
                graph.add_edge(conn)
    return graph

func _connect_rooms() -> Array:
    var connections = []
    var graph = _produce_adjacency_graph()
    var total_nodes = len(graph.get_vertices())
    var visited = [_grid.get_value(Vector2(0, 0))]
    var edges = graph.get_edges().duplicate() # We'll be modifying it so duplicate it, just in case.
    edges.shuffle()
    var edge_count = len(edges)

    while len(visited) < total_nodes:
        var i = 0
        while i < edge_count:
            var conn = edges[i]
            var a = graph.incidence0(conn)
            var b = graph.incidence1(conn)
            if visited.has(a) != visited.has(b):
                connections.append(conn)
                if not visited.has(a):
                    visited.append(a)
                if not visited.has(b):
                    visited.append(b)
                edge_count -= 1
                edges[i] = edges[edge_count]
                edges[edge_count] = conn
            else:
                i += 1

    for i in range(edge_count):
        # Add 5% of the extras back
        var conn = edges[i]
        if randf() < 0.05:
            connections.append(conn)

    return connections

func run() -> Array:
    return _connect_rooms()
