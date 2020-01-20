#!/usr/bin/prolog
%% -*- Prolog -*-

%% Welcome to the rabbit hole. If you're reading this file, you're
%% definitely not looking at the game's source code anymore. This is
%% the magic that validates all of the logic puzzles. It ensures that
%% they have exactly one unique solution and that that solution is the
%% one I declared. You shouldn't need to invoke this file directly;
%% validate.py will invoke it for you.

:-
    use_module(library(http/json)),
    use_module(library(clpb)).

% read_file(+Filename, -Dict)
read_file(Filename, Dict) :-
    open(Filename, read, Stream),
    json_read_dict(Stream, Dict),
    close(Stream).

% instantiate_player_keys(+Puzzle, -Player_Keys)
instantiate_player_keys(Puzzle, Player_Keys) :-
    get_players(Puzzle, Player_Dict),
    dict_dissect(Player_Dict, _, Players, _),
    length(Players, N),
    length(Player_Arr, N),
    maplist(player_keys_bind, Players, Player_Arr, Player_List),
    put_dict(Player_List, _{}, Player_Keys).

player_keys_bind(Player, V, Out) :-
    atom_string(Key, Player),
    (Key=V) = Out.

% get_players(+Puzzle, -Players)
get_players(Puzzle, Players) :-
    Players = (Puzzle.players).

% dict_helper(?K, ?V, ?KV)
dict_helper(K, V, K-V).

% dict_dissect(+Dict, ?Tag, ?Keys, ?Values)
dict_dissect(Dict, Tag, Keys, Values) :-
    dict_pairs(Dict, Tag, Pairs),
    maplist(dict_helper, Keys, Values, Pairs).

json_expr_or_helper(D, Acc, Expr) :-
    D + Acc = Expr.

json_expr_and_helper(D, Acc, Expr) :-
    D * Acc = Expr.

% json_expr(+Player_Keys, +Json_Statement, -Expr)
json_expr(Player_Keys, Json_Statement, Player_Keys.Key) :-
    string(Json_Statement),
    atom_string(Key, Json_Statement).
json_expr(Player_Keys, _{ op: "not", target: Json_Statement }, ~Expr) :-
    json_expr(Player_Keys, Json_Statement, Expr).
json_expr(Player_Keys, _{ op: "or", target: Json_Array }, Expr) :-
    maplist(json_expr(Player_Keys), Json_Array, Disj_Array),
    foldl(json_expr_or_helper, Disj_Array, 0, Expr).
json_expr(Player_Keys, _{ op: "and", target: Json_Array }, Expr) :-
    maplist(json_expr(Player_Keys), Json_Array, Disj_Array),
    foldl(json_expr_and_helper, Disj_Array, 1, Expr).

% solve_constraints(+Player_Keys, +Stmts, -Solns)
solve_constraints(Player_Keys, Stmts, Solns) :-
    dict_dissect(Player_Keys, _, _, Values),
    findall(Player_Keys,
            ( maplist(sat, Stmts), labeling(Values) ),
            Solns).

main_helper(Player_Keys, Name-Player, Stmt) :-
    json_expr(Player_Keys, Player.statement, Expr),
    Stmt = (Player_Keys.Name =:= Expr).

get_filename(Filename) :-
    current_prolog_flag(argv, Argv),
    (Argv = [Filename|_]) ; (
        writeln(user_error, "Usage: ./validate_puzzle.pl <filename>"),
        halt(1)
    ).

% TODO Compare against the given solution in the file.
:-
    get_filename(Filename),
    read_file(Filename, Dict),
    Puzzle = (Dict.puzzle),
    instantiate_player_keys(Puzzle, Player_Keys),
    get_players(Puzzle, Players),
    dict_pairs(Players, _, Player_List),
    maplist(main_helper(Player_Keys), Player_List, Stmts),
    solve_constraints(Player_Keys, Stmts, Solns),
    writeln(Solns),
    halt.
