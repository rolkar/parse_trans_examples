IN=-pa ebin -pa ../parse_trans/ebin
OUT=-o ebin
OPTIONS=${IN} ${OUT}

PARENTCHILD=ebin/transform_parent.beam ebin/transform_child.beam ebin/parent.beam ebin/child.beam
RECORDER=ebin/recorder.beam ebin/test_recorder.beam

.PHONY: all parentchild recorder start test test_parentchild test_recorder clean

all: parentchild recorder

parentchild: ${PARENTCHILD}

recorder: ${RECORDER}

ebin/transform_parent.beam : src/transform_parent.erl
	erlc ${OUT} src/transform_parent.erl

ebin/transform_child.beam : src/transform_child.erl
	erlc ${OPTIONS} src/transform_child.erl

ebin/parent.beam : src/parent.erl ebin/transform_parent.beam
	erlc ${OPTIONS} src/parent.erl

ebin/child.beam : src/child.erl ebin/parent.beam ebin/transform_child.beam
	erlc ${OPTIONS} src/child.erl

ebin/recorder.beam : src/recorder.erl
	erlc ${OPTIONS} src/recorder.erl

ebin/test_recorder.beam : src/test_recorder.erl
	erlc ${OUT} src/test_recorder.erl

start: all
	erl -pa ebin

test_parentchild: parentchild
	erl -pa ebin -eval "child:foo(), halt()."

test_recorder: recorder
	erl -pa ebin -eval "test_recorder:tst(), halt()."

test: test_parentchild test_recorder

clean:
	-rm ebin/*.beam
	-rm *~ src/*~ include/*~
