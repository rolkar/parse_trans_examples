-module(transform_child2).

-export([parse_transform/2]).

%%% The API call

parse_transform(Forms1, _Options) ->
    io:format("Running parse transform ~p~n", [?MODULE]),
    io:format("Forms1 = ~p~n", [Forms1]),
    PartFun = fun(Form) -> element(1, Form) == attribute end, 
    {AttributeForms, Forms2} = lists:partition(PartFun, Forms1),
    {eof, Line} = lists:last(Forms2),
    FooForm = pt_util:replace_line(Line, parent2:get_foo()),
    Forms3 = AttributeForms ++ [FooForm] ++ Forms2,
    io:format("Forms3 = ~p~n", [Forms3]),

    [ io:put_chars([erl_pp:form(Form), "\n"]) || Form <- Forms3 ],

    Forms3.
