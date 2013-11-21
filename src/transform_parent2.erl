-module(transform_parent2).

-compile({parse_transform, parse_trans_codegen}).

-export([parse_transform/2]).

parse_transform(Forms1, _Options) ->
    io:format("Running parse transform ~p~n", [?MODULE]),
    io:format("Forms1 = ~p~n", [Forms1]),
    {AttributeForms, Forms2} = pt_util:partition_attributes(Forms1),
    Forms3 =
        case pt_util:find_function(foo, 1, Forms2) of
            none ->
                io:format("Could not find foo~n", []),
                Forms1;
            FooForm ->
                ExportGetFooForm = {attribute, 1, export, [{get_foo,0}]},
                GetFooForm = 
                    codegen:gen_function(get_foo,
                                         fun() ->
                                                 {'$var', FooForm}
                                         end),
                AttributeForms ++ [ExportGetFooForm] ++ [GetFooForm] ++ Forms2
        end,
    io:format("Forms3 = ~p~n", [Forms3]),

    [ io:put_chars([erl_pp:form(Form), "\n"]) || Form <- Forms3 ],

    Forms3.
