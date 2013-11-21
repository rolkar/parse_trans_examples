-module(transform_oo).

-export([parse_transform/2]).

parse_transform(Forms1, _Options) ->
    io:format("Running parse transform ~p~n", [?MODULE]),
    io:format("Forms1 = ~p~n", [Forms1]),
    {AttributeForms, Forms2} = pt_util:partition_attributes(Forms1),

    {_,_,_,Super} = pt_util:find_attribute(super, AttributeForms),
    io:format("Super = ~p~n", [Super]),

    {_,_,_,Methods} = pt_util:find_attribute(methods, AttributeForms),
    io:format("Methods = ~p~n", [Methods]),

    Codes = [ {function,_,_,_,_} = pt_util:find_function(Name, Arity, Forms2) || {Name, Arity} <- Methods ],
    io:format("Codes = ~p~n", [Codes]),

    Forms3 = AttributeForms ++ Forms2,
    io:format("Forms1 = ~p~n", [Forms3]),
    Forms3.
