extends Reference

var _adjacency: Dictionary
var _incidence

# General Note: The vertex set and edge set should be disjoint. Bad
# things will happen for many, many reasons if a single value tries to
# act simultaneously as both a vertex and an edge. Phrased precisely,
# bad things will happen if a vertex v is ever equal to an edge e, as
# in (v == e).

# The incidence "function" should be an object with an incidence()
# function. This function shall take one argument, an edge which has
# been added to the graph, and return the two vertices incident to the
# edge as a list. This class represents undirected graphs, so the
# order of the two return values is irrelevant.
func _init(vertices: Array, incidence) -> void:
    _adjacency = {}
    _incidence = incidence

    for v in vertices:
        add_vertex(v)

func add_vertex(vertex) -> void:
    if not _adjacency.has(vertex):
        _adjacency[vertex] = []

func has_vertex(vertex) -> bool:
    return _adjacency.has(vertex)

func get_vertices() -> Array:
    return _adjacency.keys()

# Note that this simply concatenates all incidence lists, so each edge
# will be listed twice in this array.
func get_edges() -> Array:
    var edges = []
    for es in _adjacency.values():
        for e in es:
            edges.append(e)
    return edges

func get_incident_edges(vertex) -> Array:
    return _adjacency[vertex]

func add_edge(edge) -> void:
    var vs = _incidence.incidence(edge)
    _adjacency[ vs[0] ].append(edge)
    _adjacency[ vs[1] ].append(edge)

func incidence(edge) -> Array:
    return _incidence.incidence(edge)

func incidence0(edge):
    return incidence(edge)[0]

func incidence1(edge):
    return incidence(edge)[1]

func incidence_other(vertex, edge):
    var vs = incidence(edge)
    if vertex == vs[0]:
        return vs[1]
    else:
        return vs[0]
