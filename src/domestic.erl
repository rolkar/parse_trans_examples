-module(domestic).

-compile({parse_transform, transform_oo}).

-super([animal]).

-methods([tame/0, usage/0]).

tame() ->
    yes.

usage() ->
    none.
