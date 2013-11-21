-module(ant).

-compile({parse_transform, transform_oo}).

-super([insect]).

-methods([flies/0]).

flies() ->
    sometimes.
