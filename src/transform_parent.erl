-module(transform_parent).

-export([parse_transform/2]).

-record(state, {exports = []}).

parse_transform(Forms1, Options) ->
    io:format("Running parse transform ~p~n", [?MODULE]),
    io:format("Forms1 = ~p~n", [Forms1]),
    {Forms2, State} =
        parse_trans:transform(fun do_transform/4,
                              #state{},
                              Forms1,
                              Options),
    io:format("Forms2 = ~p~n", [Forms2]),
    [File,Module | Forms3] = Forms2,
    io:format("Forms3 = ~p~n", [Forms3]),
    ExportForms = [{attribute,1,export,State#state.exports}],
    Forms4 = [File,Module] ++ ExportForms ++ Forms3,
    io:format("Forms4 = ~p~n", [Forms4]),
    Forms4.

do_transform(function, {function,_,foo,1,_}=Form, _Context, State) ->
    io:format("FOO~n", []),
    io:format("Form = ~p~n", [Form]),
    Exports = [{foo,1} | State#state.exports],
    {Form, false, State#state{exports = Exports}};
do_transform(Type, Form, _Context, State) ->
    io:format("Type = ~p~n", [Type]),
    io:format("Form = ~p~n", [Form]),
    {Form, false, State}.
