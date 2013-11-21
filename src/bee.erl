-module(bee).

-compile({parse_transform, transform_oo}).

-super([domestic,insect]).

-methods([usage/0, flies/0]).

usage() ->
    honey.

flies() ->
    yes.
