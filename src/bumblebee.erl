-module(bumblebee).

-compile({parse_transform, transform_oo}).

-super([bee]).

-methods([clumsy/0]).

clumsy() ->
    yes.
