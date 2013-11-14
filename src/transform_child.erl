-module(transform_child).

-compile({parse_transform, parse_trans_codegen}).

-export([parse_transform/2]).


%%% The API call

parse_transform(Forms1, _Options) ->
    io:format("Running parse transform ~p~n", [?MODULE]),
    io:format("Forms1 = ~p~n", [Forms1]),
    Forms2 = transform(Forms1),
    io:format("Forms2 = ~p~n", [Forms2]),
    Forms2.


%%% Help function, calling parse_trans:transform/4

transform(Forms) ->
    io:format("Do transform: ~p~n", [Forms]),
    State = undefined,
    Options = [],
    {NewForms, _NewState} =
        parse_trans:transform(fun do_transform/4, State, Forms, Options),
    NewForms.


%%% Callback for parse_trans:transform/4

do_transform(Type, Form1, _Context, State) ->
    io:format("Type = ~p~n", [Type]),
    io:format("Form1 = ~p~n", [Form1]),
    Form2 =
        case Type of
            eof_marker ->
                Form1;
            attribute ->
                Form1;
            function ->
                {function,L,Name,Arity,Clauses1}=Form1,
                io:format("Clauses1 = ~p~n", [Clauses1]),
                Clauses2 = transform(Clauses1),
                io:format("Clauses2 = ~p~n", [Clauses2]),
                {function,L,Name,Arity,Clauses2};
            clause ->
                {clause,L,Args,Guard,Applications1}=Form1,
                io:format("Applications1 = ~p~n", [Applications1]),
                Applications2 = transform(Applications1),
                io:format("Applications2 = ~p~n", [Applications2]),
                {clause,L,Args,Guard,Applications2};
            application ->
                case Form1 of
                    {call, L1, C1 = {atom, L2, foo}, [{string,L3,String}]} ->
                        C2a = {call, L1, {remote, L2, {atom, L2, parent}, {atom, L2, foo}}, [{string,L3,String}]},
                        [C2b] = codegen:exprs(fun() -> parent:foo({'$var',String}) end),
                        io:format("C1 = ~p~n", [C1]),
                        io:format("C2a = ~p~n", [C2a]),
                        io:format("C2b = ~p~n", [C2b]),
                        C2b;
                    _ ->
                        Form1
                end;
            _ ->
                if
                    is_tuple(Form1) ->
                        list_to_tuple([ if is_list(F) -> transform(F); true -> F end || F <- tuple_to_list(Form1) ]);
                    true ->
                        io:format("WARNING - form not a tuple~n", []),
                        Form1
                end
        end,
    io:format("Form2 = ~p~n", [Form2]),
    {Form2, false, State}.
