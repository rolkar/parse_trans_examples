-module(animal).

-compile({parse_transform, transform_oo}).

-super([]).

-methods([legs/0, flies/0]).

legs() ->
    0.

flies() ->
    no.
