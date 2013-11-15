-module(test_recorder).

-export([tst/0]).

tst() ->
    7 = recorder:'#get-'(x, recorder:'#set-'([{x,7}], recorder:'#new-foo'())).
