-module(parent2).

-compile({parse_transform, transform_parent2}).

 %% Just to avoid compiler warnings. No one is really going to use it.
-export([foo/1]).

foo(hulahopp) ->
    io:format("hulahopp?~n", []);
foo(Message) ->
    io:format("foo: ~p~n", [Message]).
