
:- use_module(library(readutil)).

:- use_module(network).
:- use_module(bfs).
:- use_module(dfs).
:- use_module(dijkstra).
:- use_module(greedy).

% Main program
main :-

    writeln('Computer Network Search Comparison'),

    write('Enter the starting computer: '),
    read_line_to_string(user_input, StartInput),

    write('Enter the destination computer: '),
    read_line_to_string(user_input, GoalInput),

    % Convert input to lowercase atoms
    normalize_computer(StartInput, Start),
    normalize_computer(GoalInput, Goal),

    % Validate the computers
    ( computer(Start), computer(Goal) ->

        compare_algorithms(Start, Goal)

    ;

        writeln('Invalid computer name. Please use A through F.')
    ).

% Convert input strings into Prolog atoms
normalize_computer(Input, Computer) :-
    string_lower(Input, Lower),
    atom_string(Computer, Lower).

% Compare all four algorithms
compare_algorithms(Start, Goal) :-

    format('~nComparing routes from ~w to ~w~n~n',
           [Start, Goal]),

    writeln('Algorithm | Route | Path Length | Nodes Explored | Time (ms) | Cost (ms)'),

    % BFS
    get_time(T1),
    bfs(Start, Goal, BFSPath, BFSExplored),
    get_time(T2),
    BFSTime is (T2 - T1) * 1000,

    print_result('BFS', BFSPath, BFSExplored, BFSTime, calculate),

    % DFS
    get_time(T3),
    dfs(Start, Goal, DFSPath, DFSExplored),
    get_time(T4),
    DFSTime is (T4 - T3) * 1000,

    print_result('DFS', DFSPath, DFSExplored, DFSTime, calculate),

    % Dijkstra
    get_time(T5),
    dijkstra(Start, Goal, DijkstraPath,
             DijkstraExplored, DijkstraCost),
    get_time(T6),
    DijkstraTime is (T6 - T5) * 1000,

    print_result('Dijkstra', DijkstraPath,
                 DijkstraExplored, DijkstraTime, DijkstraCost),

    % Greedy
    get_time(T7),
    greedy(Start, Goal, GreedyPath, GreedyExplored),
    get_time(T8),
    GreedyTime is (T8 - T7) * 1000,

    print_result('Greedy', GreedyPath,
                 GreedyExplored, GreedyTime, calculate).

% Display algorithm results
print_result(Name, Path, Explored, TimeMs, ProvidedCost) :-

    ( Path == [] ->

        Route = 'No route',
        PathLength = 'N/A',
        Cost = 'N/A'

    ;

        % Display uppercase computer names
        maplist(upcase_atom, Path, UpperPath),

        atomic_list_concat(UpperPath, ' -> ', Route),

        length(Path, NumberOfNodes),
        PathLength is NumberOfNodes - 1,

        % Calculate route cost if needed
        ( ProvidedCost == calculate ->
            path_cost(Path, Cost)
        ;
            Cost = ProvidedCost
        )
    ),

    format('~w | ~w | ~w | ~w | ~3f | ~w~n',
           [Name, Route, PathLength,
            Explored, TimeMs, Cost]).

% Calculate total latency along a route
path_cost([_], 0).

path_cost([A, B | Rest], Total) :-

    edge_cost(A, B, EdgeCost),

    path_cost([B | Rest], RemainingCost),

    Total is EdgeCost + RemainingCost.
