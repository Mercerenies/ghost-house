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
    use_module(library(clpb)),
    use_module(library(record)).

:-
    record player_key(truth).

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
    make_player_key([truth(_)], V),
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

% player_key_access(?Key, ?Query, ?Value)
player_key_access(Key, truth, Value) :-
    player_key_truth(Key, Value).

% json_expr(+Player_Keys, +Json_Statement, -Expr)
json_expr(Player_Keys, _{ op: "atomic", name: Player_Name, query: Query }, Expr) :-
    player_key_access(Player_Keys.Key, Query_Atom, Expr),
    string(Player_Name),
    string(Query),
    atom_string(Query_Atom, Query),
    atom_string(Key, Player_Name).
json_expr(Player_Keys, _{ op: "not", target: Json_Statement }, ~Expr) :-
    json_expr(Player_Keys, Json_Statement, Expr).
json_expr(Player_Keys, _{ op: "or", target: Json_Array }, Expr) :-
    maplist(json_expr(Player_Keys), Json_Array, Disj_Array),
    Expr = +(Disj_Array).
json_expr(Player_Keys, _{ op: "and", target: Json_Array }, Expr) :-
    maplist(json_expr(Player_Keys), Json_Array, Conj_Array),
    Expr = *(Conj_Array).

% concat_map(+F, +Input, -Output)
% (F should provide difference lists; output will be a difference list)
concat_map(_, [], T0-T0).
concat_map(F, [H|T], H0-T0) :-
    call(F, H, H0-X),
    concat_map(F, T, X-T0).

extract_vars_from_key(Key, Vars-T) :-
    player_key_truth(Key, V1),
    Vars = [V1|T].

% solve_constraints(+Player_Keys, +Stmts, -Solns)
solve_constraints(Player_Keys, Stmts, Solns) :-
    dict_dissect(Player_Keys, _, _, Values),
    concat_map(extract_vars_from_key, Values, Vars-[]),
    findall(Player_Keys,
            ( maplist(sat, Stmts), labeling(Vars) ),
            Solns).

main_helper(Player_Keys, Name-Player, Stmt) :-
    json_expr(Player_Keys, Player.statement, Expr),
    player_key_truth(Player_Keys.Name, Own_Truth),
    Stmt = (Own_Truth =:= Expr).

get_filename(Filename) :-
    current_prolog_flag(argv, Argv),
    (Argv = [Filename|_]) ; (
        writeln(user_error, "Usage: ./validate_puzzle.pl <filename>"),
        halt(1)
    ).

analyze_solutions_truth(Given_Soln, K, 0) :-
    atom_string(K, K1),
    \+ member(K1, Given_Soln.truth).
analyze_solutions_truth(Given_Soln, K, 1) :-
    atom_string(K, K1),
    member(K1, Given_Soln.truth).

analyze_solutions_check(Given_Soln, K-V) :-
    player_key_truth(V, Truth),
    analyze_solutions_truth(Given_Soln, K, Truth).

analyze_solutions1(Given_Soln, [Soln], correct) :-
    dict_pairs(Soln, _, Pairs),
    maplist(analyze_solutions_check(Given_Soln), Pairs).
analyze_solutions1(_, [Soln], incorrect_given(Soln)).
analyze_solutions1(_, Solns, ambiguous(Solns)).

% analyze_solutions(+Given_Soln, +Solns, ?Verdict)
analyze_solutions(Given_Soln, Solns, Verdict) :-
    once(analyze_solutions1(Given_Soln, Solns, Verdict)).

% output_verdict(?Verdict, ?Exit_Code)
output_verdict(correct, 0).
output_verdict(incorrect_given(Soln), 1) :-
    write(user_error, "Incorrect solution, correct answer is: "),
    write(user_error, Soln),
    nl(user_error).
output_verdict(ambiguous(Solns), 1) :-
    write(user_error, "Ambiguous puzzle, possible solutions are: "),
    write(user_error, Solns),
    nl(user_error).

:-
    % Read the file and extract the puzzle.
    get_filename(Filename),
    read_file(Filename, Dict),
    Puzzle = (Dict.puzzle),
    % Construct a dictionary of keys to contain the solution.
    instantiate_player_keys(Puzzle, Player_Keys),
    % Extract the clues from each player.
    get_players(Puzzle, Players),
    dict_pairs(Players, _, Player_List),
    maplist(main_helper(Player_Keys), Player_List, Stmts),
    % Find all solutions.
    solve_constraints(Player_Keys, Stmts, Solns),
    analyze_solutions(Puzzle.solution, Solns, Verdict),
    output_verdict(Verdict, Exit_Code),
    halt(Exit_Code).
