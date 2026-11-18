
:- module(bfs, [bfs/4]).

:- use_module(network, [neighbor/2]).

% Start Breadth-First Search
bfs(Start, Goal, Path, Explored) :-
    bfs_loop([[Start]], Goal, [Start], Path, 0, Explored).

% No route found
bfs_loop([], _, _, [], Count, Count).

% Process the queue
bfs_loop([CurrentPath | Rest], Goal, Visited0,
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

        % Extend the current paths
        extend_paths(CurrentPath, Neighbors, NewPaths),

        % Add new paths to the end of the queue
        append(Rest, NewPaths, Queue1),

        bfs_loop(Queue1, Goal, Visited1,
                 Path, Count1, Count)
    ).

% Add each neighbor to the current path
extend_paths(_, [], []).

extend_paths(CurrentPath, [Neighbor | Rest],
             [NewPath | OtherPaths]) :-

    append(CurrentPath, [Neighbor], NewPath),

    extend_paths(CurrentPath, Rest, OtherPaths).
