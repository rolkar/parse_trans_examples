-module(child2).

-compile({parse_transform, transform_child}).

-export([bar/0, bar/1]).

bar() ->
    bar(42).

bar(Int) ->
    if
        Int > 9 ->
            foo("Int > 9");
        true ->
            case Int of
                0 ->
                    foo("Int = 0");
                _ ->
                    foo("Hello")
            end
    end.
