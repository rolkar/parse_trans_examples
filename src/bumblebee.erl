-module(bumblebee).

-compile({parse_transform, transform_oo}).

-super([bee]).

-methods([clumsy/1]).

clumsy() ->
    yes.
