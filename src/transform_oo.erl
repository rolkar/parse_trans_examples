-module(transform_oo).

-compile({parse_transform, parse_trans_codegen}).

-export([parse_transform/2]).

parse_transform(Forms1, _Options) ->
    io:format("Running parse transform ~p~n", [?MODULE]),
    io:format("Forms1 = ~p~n", [Forms1]),
    {AttributeForms, Forms2} = pt_util:partition_attributes(Forms1),

    {attribute,_L0,module,Module} = pt_util:find_attribute(module, AttributeForms),
    io:format("Module = ~p~n", [Module]),

    {attribute,_L1,super,Super} = pt_util:find_attribute(super, AttributeForms),
    io:format("Super = ~p~n", [Super]),

    {attribute,L2,methods,Methods} = pt_util:find_attribute(methods, AttributeForms),
    io:format("Methods = ~p~n", [Methods]),

    ExportForm = {attribute, L2, export, Methods},

    Codes = [ {function,_,_,_,_} = pt_util:find_function(Name, Arity, Forms2) || {Name, Arity} <- Methods ],
    io:format("Codes = ~p~n", [Codes]),

    Forms3 = AttributeForms ++ [ExportForm] ++ Forms2,
    io:format("Forms3 = ~p~n", [Forms3]),

    make_tmp_beam(Module, Super, Methods, Codes),

    Forms3.

make_tmp_beam(Module, Super, Methods, Codes) ->
    %% TODO: Dir should be configurable
    Dir = "tmp",
    TmpModule = tmp_module(Module),
    TmpErlFile = tmp_erl_file(Module),
    TmpBeamFile = tmp_beam_file(Module),

    io:format("Make tmp beam: ~p ~p ~p ~p~n", [Dir,TmpModule,TmpErlFile,TmpBeamFile]),

    HeaderForms = [{attribute, 1, file, {TmpErlFile,1}},
                   {attribute, 2, module, TmpModule}],
    ExportForms = [{attribute, 3, export, [{get_super,0},
                                           {get_methods,0},
                                           {get_codes,0}]}],
    GetterForms = [codegen:gen_function(get_super,   fun() -> {'$var', Super}  end),
                   codegen:gen_function(get_methods, fun() -> {'$var', Methods} end),
                   codegen:gen_function(get_codes,   fun() -> {'$var', Codes}   end)],
    FooterForms = [{eof,6}],
    Forms = HeaderForms ++ ExportForms ++ GetterForms ++ FooterForms,

    {ok,TmpModule,Compiled} = compile:forms(Forms),
    BeamFile = filename:join([Dir,TmpBeamFile]),

    io:format("BeamFile = ~p~n", [BeamFile]),

    ok = file:write_file(BeamFile, Compiled),
    
    Src = [ [erl_pp:form(Form), "\n"] || Form <- Forms ],
    ErlFile = filename:join([Dir,TmpErlFile]),

    io:format("BeamFile = ~p~n", [BeamFile]),
    
    ok = file:write_file(ErlFile, Src).    

%%% Private help functions

tmp_erl_file(Module) ->
    atom_to_list(Module) ++ "_tmp.erl".

tmp_beam_file(Module) ->
    atom_to_list(Module) ++ "_tmp.beam".

tmp_module(Module) ->
    list_to_atom(atom_to_list(Module) ++ "_tmp").
