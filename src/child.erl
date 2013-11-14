-module(child).

-compile({parse_transform, transform_child}).

-export([foo/0]).

foo() ->
    if
        10 > 9 ->
            foo("10 > 9");
        true ->
            case a of
                a ->
                    foo("a");
                _ ->
                    foo("Hello")
            end
    end.
