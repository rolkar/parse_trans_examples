Tests of Ulf Wigers parse_trans package
=======================================

0. Installation
---------------

* mkdir and cd where you want to put the things
* git clone https://github.com/uwiger/parse_trans.git
* git clone https://github.com/rolkar/parse_trans_examples.git
* cp parse_trans_examples/Makefile.top Makefile
* make


1. Parent child
---------------

The first test contains the two files parent.erl and child.erl.

The file parent.erl contains a function (foo/1) that is neither
used nor exported. The transform (transform_parent.erl) simply
exports that function.

The file child .erl calls foo/1 locally, even if it does not exist.
This call is replaced by parent:foo/1. So - when running child:bar/0,
then parent:foo/1 is called instead.

2. Parent child 2
-----------------

This is a similar example as the one above. But, instaed of
manipulating the export and calls we actually inline code
from the parent to the child. This means that the code for
foo/1 is copied from parent to child.

3. exprecs
----------

The second test contains the two files recorder.erl and
test_recorder.erl.

The first file implements a simple exprecs module, which
automatically creates access functions to records.

The second file is a test for the functionality.


