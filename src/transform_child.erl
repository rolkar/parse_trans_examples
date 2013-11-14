-module(transform_child).

-compile({parse_transform, parse_trans_codegen}).

-export([parse_transform/2]).

-export([do_transform/4]).

-record(state, {}).

parse_transform(Forms1, Options) ->
    io:format("Running parse transform ~p~n", [?MODULE]),
    io:format("Forms1 = ~p~n", [Forms1]),
    {Forms2, _State} =
        parse_trans:transform(fun do_transform/4,
                              #state{},
                              Forms1,
                              Options),
    io:format("Forms2 = ~p~n", [Forms2]),
    Forms2.

do_transform(function, {function,L,Name,Arity,Clauses}, _Context, State) ->
    Clauses2 = [ do_transform_clause(Clause) || Clause <- Clauses ],
    {{function,L,Name,Arity,Clauses2}, false, State};
do_transform(Type, Form, _Context, State) ->
    io:format("Type = ~p~n", [Type]),
    io:format("Form = ~p~n", [Form]),
    {Form, false, State}.

do_transform_clause({clause, L, Args, Guard, Body}) ->
    Body2 = [ do_transform_statement(Statement) || Statement <- Body ],
    {clause, L, Args, Guard, lists:flatten(Body2)}.

do_transform_statement({call, L1, {atom, L2, foo}, [Arg]}) ->
    C1 = codegen:exprs(fun() -> parent:foo("Hello") end),
    C2 = {call, L1, {remote, L2, {atom, L2, parent}, {atom, L2, foo}}, [Arg]},
    io:format("C1 = ~p~n", [C1]),
    io:format("C2 = ~p~n", [C2]),
    C1;
do_transform_statement(Statement) ->
    Statement.
