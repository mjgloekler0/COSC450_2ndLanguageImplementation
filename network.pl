
:- module(network, [
    computer/1,
    neighbor/2,
    edge_cost/3,
    heuristic/2
]).

% Computers in the network
computer(a).
computer(b).
computer(c).
computer(d).
computer(e).
computer(f).

% Connections and latency costs
% Each connection is listed in both directions.

link(a, b, 4).
link(a, c, 2).

link(b, a, 4).
link(b, d, 5).

link(c, a, 2).
link(c, e, 8).

link(d, b, 5).
link(d, f, 3).

link(e, c, 8).
link(e, f, 2).

link(f, d, 3).
link(f, e, 2).

% Find neighboring computers
neighbor(X, Y) :-
    link(X, Y, _).

% Find the latency cost between two computers
edge_cost(X, Y, Cost) :-
    link(X, Y, Cost).

% Heuristic estimates to computer F
heuristic(a, 7).
heuristic(b, 6).
heuristic(c, 5).
heuristic(d, 3).
heuristic(e, 2).
heuristic(f, 0).
