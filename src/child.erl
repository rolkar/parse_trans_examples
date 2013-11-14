-module(child).

-compile({parse_transform, transform_child}).

-export([foo/0]).

foo() ->
    foo("Hello").
