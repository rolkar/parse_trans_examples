-module(transform_oo).

-export([parse_transform/2]).

parse_transform(Forms1, _Options) ->
    io:format("Running parse transform ~p~n", [?MODULE]),
    io:format("Forms1 = ~p~n", [Forms1]),
    {AttributeForms, Forms2} = pt_util:partition_attributes(Forms1),
    Forms3 = AttributeForms ++ Forms2,
    io:format("Forms1 = ~p~n", [Forms3]),
    Forms3.
