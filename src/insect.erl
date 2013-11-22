-module(insect).

-compile({parse_transform, transform_oo}).

-super([animal]).

-methods([legs/0]).

legs() ->
    6.
