-module(mamal).

-compile({parse_transform, transform_oo}).

-super([animal]).

-methods([breastfeed/0]).

breastfeed() ->
    yes.
