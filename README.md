Tests of Ulf Wigers parse_trans package
=======================================

1. Parent child
---------------

The first test contains the two files parent.erl and child.erl.

The file parent.erl contains a function (foo/1) that is neither
used nor exported. The transform (transform_parent.erl) simply
exports that function.

The file child .erl calls foo/1 locally, even if it does not exist.
This call is replaced by parent:foo/1. So - when running child:foo/0,
then parent:foo/1 is called instead.

2. exprecs
----------

TODO
