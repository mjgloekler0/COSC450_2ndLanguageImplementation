
:- module(dijkstra, [dijkstra/5]).

:- use_module(library(heaps)).
:- use_module(library(assoc)).
:- use_module(network, [edge_cost/3]).

% Start Dijkstra's Algorithm
dijkstra(Start, Goal, Path, Explored, TotalCost) :-

    empty_heap(EmptyHeap),

    add_to_heap(
        EmptyHeap,
        key(0, Start),
        state(Start, [Start], 0),
        Heap
    ),

    empty_assoc(EmptyCosts),
    put_assoc(Start, EmptyCosts, 0, BestCosts),

    dijkstra_loop(Heap, Goal, BestCosts,
                  Path, 0, Explored, TotalCost).

% No route found
dijkstra_loop(Heap, _, _, [], Count, Count, none) :-
    heap_size(Heap, 0), !.

% Process the priority queue
dijkstra_loop(Heap0, Goal, BestCosts0,
              Path, Count0, Count, TotalCost) :-

    get_from_heap(
        Heap0, _,
        state(Current, CurrentPath, Cost),
        Heap1
    ),

    get_assoc(Current, BestCosts0, BestKnown),

    % Ignore an outdated route
    ( Cost > BestKnown ->

        dijkstra_loop(Heap1, Goal, BestCosts0,
                      Path, Count0, Count, TotalCost)

    ;

        Count1 is Count0 + 1,

        % Check destination
        ( Current == Goal ->

            Path = CurrentPath,
            Count = Count1,
            TotalCost = Cost

        ;

            % Find connected computers and their costs
            findall(Neighbor-EdgeCost,
                edge_cost(Current, Neighbor, EdgeCost),
                Neighbors),

            relax_neighbors(
                Neighbors,
                CurrentPath,
                Cost,
                Heap1,
                BestCosts0,
                Heap2,
                BestCosts1
            ),

            dijkstra_loop(
                Heap2, Goal, BestCosts1,
                Path, Count1, Count, TotalCost
            )
        )
    ).

% Update neighboring computers when a cheaper route is found
relax_neighbors([], _, _, Heap, Costs, Heap, Costs).

relax_neighbors([Neighbor-EdgeCost | Rest],
                CurrentPath, CurrentCost,
                Heap0, Costs0, Heap, Costs) :-

    NewCost is CurrentCost + EdgeCost,

    ( get_assoc(Neighbor, Costs0, OldCost) ->

        ( NewCost < OldCost ->

            append(CurrentPath, [Neighbor], NewPath),

            put_assoc(Neighbor, Costs0, NewCost, Costs1),

            add_to_heap(
                Heap0,
                key(NewCost, Neighbor),
                state(Neighbor, NewPath, NewCost),
                Heap1
            )

        ;

            Costs1 = Costs0,
            Heap1 = Heap0
        )

    ;

        append(CurrentPath, [Neighbor], NewPath),

        put_assoc(Neighbor, Costs0, NewCost, Costs1),

        add_to_heap(
            Heap0,
            key(NewCost, Neighbor),
            state(Neighbor, NewPath, NewCost),
            Heap1
        )
    ),

    relax_neighbors(
        Rest, CurrentPath, CurrentCost,
        Heap1, Costs1, Heap, Costs
    ).
