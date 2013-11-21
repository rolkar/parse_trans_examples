-module(pt_util).

-export([replace_line/2,
         find_attribute/2,
         find_function/3,
         partition_attributes/1]).

%% Replace all occurances of line with a given value, either for a
%% Form or for a list of Forms.  We need to specially treat attribute
%% as Arg does not contain line numbers, Ouch!
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

%% Find the attribute Name in a list of top level forms.
find_attribute(_,[]) ->
    none;
find_attribute(Name, [Form = {attribute,_,Name,_} | _]) ->
    Form;
find_attribute(Name, [_|Forms]) ->
    find_attribute(Name, Forms).

%% Find the function Name/Arity in a list of top level forms.
find_function(_,_,[]) ->
    none;
find_function(Name, Arity, [Form = {function,_,Name,Arity,_} | _]) ->
    Form;
find_function(Name, Arity, [_|Forms]) ->
    find_function(Name, Arity, Forms).

partition_attributes(Forms) ->
    PartFun = fun(Form) -> element(1, Form) == attribute end, 
    lists:partition(PartFun, Forms).
