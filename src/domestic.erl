-module(domestic).

-compile({parse_transform, transform_oo}).

-super([animal]).

-methods([tame, unknown]).

tame() ->
    yes.

usage() ->
    none.
