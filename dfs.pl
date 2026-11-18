
:- module(dfs, [dfs/4]).

:- use_module(network, [neighbor/2]).

% Start Depth-First Search
dfs(Start, Goal, Path, Explored) :-
    dfs_loop([[Start]], Goal, [Start], Path, 0, Explored).

% No route found
dfs_loop([], _, _, [], Count, Count).

% Process the stack
dfs_loop([CurrentPath | Rest], Goal, Visited0,
         Path, Count0, Count) :-

    last(CurrentPath, Current),
    Count1 is Count0 + 1,

    % Check if we reached the goal
    ( Current == Goal ->
        Path = CurrentPath,
        Count = Count1

    ;
        % Find unvisited neighbors
        findall(Neighbor,
            ( neighbor(Current, Neighbor),
              \+ memberchk(Neighbor, Visited0)
            ),
            Neighbors),

        append(Visited0, Neighbors, Visited1),

        % Reverse neighbors for stack behavior
        reverse(Neighbors, ReverseNeighbors),

        extend_paths(CurrentPath, ReverseNeighbors, NewPaths),

        % Place new paths at the top of the stack
        append(NewPaths, Rest, Stack1),

        dfs_loop(Stack1, Goal, Visited1,
                 Path, Count1, Count)
    ).

% Extend paths
extend_paths(_, [], []).

extend_paths(CurrentPath, [Neighbor | Rest],
             [NewPath | OtherPaths]) :-

    append(CurrentPath, [Neighbor], NewPath),

    extend_paths(CurrentPath, Rest, OtherPaths).
