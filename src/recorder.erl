-module(recorder).

-compile({parse_transform, exprecs}).

%% Omit this if you want default syntax
-exprecs_prefix(["#", operation]).
-exprecs_fname([prefix, "-", record]).

-record(foo, {x, y}).

-export_records([foo]).
