-module(parent).

-compile({parse_transform, transform_parent}).

foo(hulahopp) ->
    io:format("hulahopp?~n", []);
foo(Message) ->
    io:format("foo: ~p~n", [Message]).
