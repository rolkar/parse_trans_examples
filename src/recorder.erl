-module(recorder).

-compile({parse_transform, exprecs}).

-record(foo, {x, y}).

-export_records([foo]).
