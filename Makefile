IN=-pa ebin -pa ../parse_trans/ebin
OUT=-o ebin
OPTIONS=${IN} ${OUT}

PARENTCHILD=ebin/transform_parent.beam ebin/transform_child.beam ebin/parent.beam ebin/child.beam
PARENTCHILD2=ebin/transform_parent2.beam ebin/transform_child2.beam ebin/parent2.beam ebin/child2.beam
RECORDER=ebin/recorder.beam ebin/test_recorder.beam

.PHONY: all parentchild recorder start test test_parentchild test_parentchild2 test_recorder clean

all: parentchild parentchild2 recorder

parentchild: ${PARENTCHILD}

parentchild2: ${PARENTCHILD2}

recorder: ${RECORDER}

ebin/transform_parent.beam : src/transform_parent.erl
	erlc ${OUT} src/transform_parent.erl

ebin/transform_child.beam : src/transform_child.erl
	erlc ${OPTIONS} src/transform_child.erl

ebin/parent.beam : src/parent.erl ebin/transform_parent.beam
	erlc ${OPTIONS} src/parent.erl

ebin/child.beam : src/child.erl ebin/parent.beam ebin/transform_child.beam
	erlc ${OPTIONS} src/child.erl

ebin/transform_parent2.beam : src/transform_parent2.erl
	erlc ${OPTIONS} src/transform_parent2.erl

ebin/transform_child2.beam : src/transform_child2.erl
	erlc ${OPTIONS} src/transform_child2.erl

ebin/parent2.beam : src/parent2.erl ebin/transform_parent2.beam
	erlc ${OPTIONS} src/parent2.erl

ebin/child2.beam : src/child2.erl ebin/parent2.beam ebin/transform_child2.beam
	erlc ${OPTIONS} src/child2.erl

ebin/recorder.beam : src/recorder.erl
	erlc ${OPTIONS} src/recorder.erl

ebin/test_recorder.beam : src/test_recorder.erl
	erlc ${OUT} src/test_recorder.erl

start: all
	erl -pa ebin

test_parentchild: parentchild
	erl -pa ebin -eval "child:bar(), halt()."

test_parentchild2: parentchild2
	erl -pa ebin -eval "child2:bar(), halt()."

test_recorder: recorder
	erl -pa ebin -eval "test_recorder:tst(), halt()."

test: test_parentchild test_parentchild2 test_recorder

clean:
	-rm ebin/*.beam
	-rm *~ src/*~ include/*~
