-module(test_recorder).

-export([tst/0,
         tst2/0,
         tst3/0,
         tst_default_syntax/0,
         tst_default_syntax2/0,
         tst_default_syntax3/0]).

tst() ->
    7 = recorder:'#get'(x, recorder:'#set'([{x,7}], recorder:'#new'(foo))).

tst2() ->
    7 = recorder:'#get'(x, recorder:'#set'([{x,7}], recorder:'#new-foo'())).

tst3() ->
    7 = recorder:'#get-foo'(x, recorder:'#set-foo'([{x,7}], recorder:'#new-foo'())).

tst_default_syntax() ->
    7 = recorder:'#get-'(x, recorder:'#set-'([{x,7}], recorder:'#new-'(foo))).

tst_default_syntax2() ->
    7 = recorder:'#get-'(x, recorder:'#set-'([{x,7}], recorder:'#new-foo'())).

tst_default_syntax3() ->
    7 = recorder:'#get-foo'(x, recorder:'#set-foo'([{x,7}], recorder:'#new-foo'())).
