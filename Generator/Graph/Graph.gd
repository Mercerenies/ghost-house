extends Reference

var adja: Dictionary
var _incidence

# The incidence "function" should be an object with an incidence()
# function. This function shall take one argument, an edge which has
# been added to the graph, and return the two vertices incident to the
# edge as a list. This class represents undirected graphs, so the
# order of the two return values is irrelevant.
func _init(vertices: Array, incidence) -> void:
    adja = {}
    _incidence = incidence

    for v in vertices:
        add_vertex(v)

func add_vertex(vertex) -> void:
    if not adja.has(vertex):
        adja[vertex] = []

func has_vertex(vertex) -> bool:
    return adja.has(vertex)

func get_vertices() -> Array:
    return adja.keys()

func get_edges() -> Array:
    var edges = []
    for es in adja.values():
        for e in es:
            edges.append(e)
    return edges

func add_edge(edge) -> void:
    var vs = _incidence.incidence(edge)
    adja[ vs[0] ].append(edge)
    adja[ vs[1] ].append(edge)

func incidence(edge) -> Array:
    return _incidence.incidence(edge)

func incidence0(edge):
    return incidence(edge)[0]

func incidence1(edge):
    return incidence(edge)[1]

