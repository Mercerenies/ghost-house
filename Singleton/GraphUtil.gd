extends Node

# This file consists of various utility functions for the Graph class
# which are not necessary for the class' internal API but which are
# handy nonetheless.

const Graph = preload("res://Generator/Graph/Graph.gd")

func _identify_cut_edges_iter(graph: Graph,
                              result: Dictionary,
                              visited: Dictionary,
                              stack: Array) -> void:
    var v = stack[-1]
    for e in graph.get_incident_edges(v):
        if visited.has(e):
            continue
        visited[e] = true
        var w = graph.incidence_other(v, e)
        var stack_pos = stack.find(w)
        if stack_pos >= 0:
            # We found a cycle
            result[e] = false
            for i in range(stack_pos + 1, len(stack), 2):
                result[stack[i]] = false
        else:
            stack.push_back(e)
            stack.push_back(w)
            _identify_cut_edges_iter(graph, result, visited, stack)
            stack.pop_back()
            stack.pop_back()

# Returns a dictionary where the keys are edges and the values are
# Booleans (true if the edge is a cut edge, false if not).
func identify_cut_edges(graph: Graph) -> Dictionary:
    var vs = graph.get_vertices()
    if len(vs) == 0:
        # Degenerate case: empty graph
        return {}

    var result = {}
    # Begin by assuming all edges are cut edges and then attempting to
    # disprove this.
    for e in graph.get_edges():
        result[e] = true

    # Choose an arbitrary starting vertex
    var visited = {} # We use a dictionary so we get constant-time lookups
    var stack = [vs[0]]

    # Iterate
    _identify_cut_edges_iter(graph, result, visited, stack)
    return result
