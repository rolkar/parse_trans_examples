-module(cat).

-compile({parse_transform, transform_oo}).

-super([domestic,mamal]).

-methods([usage/0, legs/0]).

usage() ->
    pet.

legs() ->
    4.
