extends Reference

####################################
# STAGE 6 - LOCKED DOOR GENERATION #
####################################

const HallwayData = GeneratorData.HallwayData
const RoomData = GeneratorData.RoomData
const GeneratorGrid = preload("res://Generator/GeneratorGrid/GeneratorGrid.gd")
const Connection = preload("res://Generator/Connection/Connection.gd")
const Graph = preload("res://Generator/Graph/Graph.gd")

const VAR_PLAYER_COORDS = GeneratorData.VAR_PLAYER_COORDS

var _data: Dictionary = {}
var _grid: GeneratorGrid = null
var _boxes: Dictionary = {}
var _vars: Dictionary = {}

func _init(room_data: Dictionary, grid: GeneratorGrid, boxes: Dictionary, vars: Dictionary):
    _data = room_data
    _grid = grid
    _boxes = boxes
    _vars = vars

func _score_edge(graph: Graph, cuts: Dictionary, edge: Connection) -> int:
    var vs = graph.incidence(edge)
    var score = 0
    var closeted_room = null

    # +10: Always
    score += 10

    # +20: Cut Edge
    if cuts[edge]:
        score += 20

    # +10: Closet Edge
    if cuts[edge]:
        for v in vs:
            # See if the vertex is "closeted"
            if len(graph.get_incident_edges(v)) == 1:
                closeted_room = v
        if closeted_room:
            score += 10

    # -30: Duplicate Edge
    var matching_edges = 0
    for e in graph.get_incident_edges(vs[0]):
        if graph.incidence_other(vs[0], e) == vs[1]:
            matching_edges += 1
    if matching_edges > 1:
        score -= 30

    # -30 Closet Edge Containing the Player
    if cuts[edge] and closeted_room:
        var player_cell = _vars[VAR_PLAYER_COORDS]
        var player_starting_id = _grid.get_value(player_cell)
        if player_starting_id == closeted_room:
            score -= 30

    return int(max(score, 1))

func _score_all_edges(graph: Graph, cuts: Dictionary) -> Dictionary:
    var scores = {}
    for e in graph.get_edges():
        scores[e] = _score_edge(graph, cuts, e)
    return scores

func _determine_locked_door_count() -> int:
    if not _data.has("locked_doors"):
        return 0
    var val = _data["locked_doors"]

    if val is Dictionary:
        return Util.randi_range(val["minimum"], val["maximum"] + 1)
    elif typeof(val) in [TYPE_INT, TYPE_REAL]:
        return int(val)

    return 0 # TODO Should we err out in the case of invalid input here?

func _choose_connection_for_lock(scores: Dictionary) -> Connection:
    if len(scores.keys()) == 0:
        return null

    var weighted = []
    for k in scores.keys():
        weighted.append({ "result": k, "weight": scores[k] })
    return Util.weighted_choose(weighted)

func _lock_connection(conn: Connection) -> void:
    conn.set_lock(Connection.LockType.SIMPLE_LOCK)

func run(conn: Array) -> void:
    var graph = Connection.make_incidence_graph(_grid, _boxes.keys(), conn)

    var count = _determine_locked_door_count()
    for _i in range(count):
        var cuts = GraphUtil.identify_cut_edges(graph)
        var scores = _score_all_edges(graph, cuts)
        var edge = _choose_connection_for_lock(scores)
        _lock_connection(edge)
        # Remove the edge from the graph so we can regenerate the
        # scores without considering that edge (i.e. some edges will
        # become cuts or closets now)
        graph.remove_edge(edge)
