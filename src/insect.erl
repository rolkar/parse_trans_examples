-module(insect).

-compile({parse_transform, transform_oo}).

-super([animal]).

-methods([legs]).

legs() ->
    6.
