-module(transform_child2).

-export([parse_transform/2]).

%%% The API call

parse_transform(Forms1, _Options) ->
    io:format("Running parse transform ~p~n", [?MODULE]),
    io:format("Forms1 = ~p~n", [Forms1]),
    PartFun = fun(Form) -> element(1, Form) == attribute end, 
    {AttributeForms, Forms2} = lists:partition(PartFun, Forms1),
    {eof, Line} = lists:last(Forms2),
    FooForm = replace_line(Line, parent2:get_foo()),
    Forms3 = AttributeForms ++ [FooForm] ++ Forms2,
    io:format("Forms3 = ~p~n", [Forms3]),

    [ io:put_chars([erl_pp:form(Form), "\n"]) || Form <- Forms3 ],

    Forms3.


%% Replace all occurances of line with a given value
%% We need to specially treat attribute as Arg does not contain line numbers, Ouch!
replace_line(_L, []) ->
    [];
replace_line(L, [H|T]) ->
    [replace_line(L, H) | replace_line(L, T)];
replace_line(L,{attribute,_,Name,Arg}) ->
    {attribute,L,Name,Arg};
replace_line(L,Tuple) when is_tuple(Tuple) ->
    case list_to_tuple(replace_line(L, tuple_to_list(Tuple))) of
        Tuple2 when is_integer(element(2, Tuple2)) ->
            setelement(2, Tuple2, L);
        Tuple2 ->
            Tuple2
    end;
replace_line(_L, X) ->
    X.
