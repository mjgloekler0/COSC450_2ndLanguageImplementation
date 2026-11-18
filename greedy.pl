
:- module(greedy, [greedy/4]).

:- use_module(library(heaps)).
:- use_module(network, [neighbor/2, heuristic/2]).

% Start Greedy Best-First Search
greedy(Start, Goal, Path, Explored) :-

    empty_heap(EmptyHeap),

    heuristic(Start, Estimate),

    add_to_heap(
        EmptyHeap,
        key(Estimate, Start),
        [Start],
        Heap
    ),

    greedy_loop(Heap, Goal, [Start], Path, 0, Explored).

% No route found
greedy_loop(Heap, _, _, [], Count, Count) :-
    heap_size(Heap, 0), !.

% Process priority queue
greedy_loop(Heap0, Goal, Visited0,
            Path, Count0, Count) :-

    get_from_heap(Heap0, _, CurrentPath, Heap1),

    last(CurrentPath, Current),
    Count1 is Count0 + 1,

    % Check destination
    ( Current == Goal ->

        Path = CurrentPath,
        Count = Count1

    ;

        % Find neighboring computers
        findall(Neighbor,
            neighbor(Current, Neighbor),
            Neighbors),

        greedy_add_neighbors(
            Neighbors,
            CurrentPath,
            Visited0,
            Heap1,
            Visited1,
            Heap2
        ),

        greedy_loop(
            Heap2, Goal, Visited1,
            Path, Count1, Count
        )
    ).

% Add unvisited neighbors using heuristic priorities
greedy_add_neighbors([], _, Visited, Heap, Visited, Heap).

greedy_add_neighbors([Neighbor | Rest],
                     CurrentPath,
                     Visited0, Heap0,
                     Visited, Heap) :-

    ( memberchk(Neighbor, Visited0) ->

        Visited1 = Visited0,
        Heap1 = Heap0

    ;

        heuristic(Neighbor, Estimate),

        append(CurrentPath, [Neighbor], NewPath),

        add_to_heap(
            Heap0,
            key(Estimate, Neighbor),
            NewPath,
            Heap1
        ),

        Visited1 = [Neighbor | Visited0]
    ),

    greedy_add_neighbors(
        Rest, CurrentPath,
        Visited1, Heap1,
        Visited, Heap
    ).
