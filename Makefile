IN=-pa ebin -pa tmp -pa ../parse_trans/ebin
OUT=-o ebin
OPTIONS=${IN} ${OUT}

PARENTCHILD=ebin/transform_parent.beam ebin/transform_child.beam ebin/parent.beam ebin/child.beam
PARENTCHILD2=ebin/transform_parent2.beam ebin/transform_child2.beam ebin/parent2.beam ebin/child2.beam
RECORDER=ebin/recorder.beam ebin/test_recorder.beam
ZOO=ebin/animal.beam ebin/domestic.beam ebin/mamal.beam ebin/insect.beam ebin/cat.beam ebin/ant.beam ebin/bee.beam ebin/bumblebee.beam
UTIL=ebin/pt_util.beam

.PHONY: all util parentchild recorder start test test_parentchild test_parentchild2 test_recorder zoo clean

all: util parentchild parentchild2 recorder zoo

util: ${UTIL}

parentchild: ${PARENTCHILD}

parentchild2: ${PARENTCHILD2}

recorder: ${RECORDER}

zoo: ${ZOO}

ebin/pt_util.beam : src/pt_util.erl
	erlc ${OUT} src/pt_util.erl

ebin/transform_parent.beam : src/transform_parent.erl
	erlc ${OUT} src/transform_parent.erl

ebin/transform_child.beam : src/transform_child.erl
	erlc ${OPTIONS} src/transform_child.erl

ebin/parent.beam : src/parent.erl ebin/transform_parent.beam ebin/pt_util.beam
	erlc ${OPTIONS} src/parent.erl

ebin/child.beam : src/child.erl ebin/parent.beam ebin/transform_child.beam ebin/pt_util.beam
	erlc ${OPTIONS} src/child.erl

ebin/transform_parent2.beam : src/transform_parent2.erl
	erlc ${OPTIONS} src/transform_parent2.erl

ebin/transform_child2.beam : src/transform_child2.erl
	erlc ${OPTIONS} src/transform_child2.erl

ebin/parent2.beam : src/parent2.erl ebin/transform_parent2.beam ebin/pt_util.beam
	erlc ${OPTIONS} src/parent2.erl

ebin/child2.beam : src/child2.erl ebin/parent2.beam ebin/transform_child2.beam ebin/pt_util.beam
	erlc ${OPTIONS} src/child2.erl

ebin/recorder.beam : src/recorder.erl
	erlc ${OPTIONS} src/recorder.erl

ebin/test_recorder.beam : src/test_recorder.erl ebin/recorder.beam
	erlc ${OUT} src/test_recorder.erl

ebin/transform_oo.beam : src/transform_oo.erl
	erlc ${OPTIONS} src/transform_oo.erl

ebin/animal.beam : src/animal.erl ebin/transform_oo.beam
	erlc ${OPTIONS} src/animal.erl

ebin/domestic.beam : src/domestic.erl ebin/transform_oo.beam ebin/animal.beam
	erlc ${OPTIONS} src/domestic.erl

ebin/mamal.beam : src/mamal.erl ebin/transform_oo.beam ebin/animal.beam
	erlc ${OPTIONS} src/mamal.erl

ebin/insect.beam : src/insect.erl ebin/transform_oo.beam ebin/animal.beam
	erlc ${OPTIONS} src/insect.erl

ebin/cat.beam : src/cat.erl ebin/transform_oo.beam ebin/mamal.beam ebin/domestic.beam
	erlc ${OPTIONS} src/cat.erl

ebin/ant.beam : src/ant.erl ebin/transform_oo.beam ebin/insect.beam
	erlc ${OPTIONS} src/ant.erl

ebin/bee.beam : src/bee.erl ebin/transform_oo.beam ebin/insect.beam ebin/domestic.beam
	erlc ${OPTIONS} src/bee.erl

ebin/bumblebee.beam : src/bumblebee.erl ebin/transform_oo.beam ebin/bee.beam
	erlc ${OPTIONS} src/bumblebee.erl

start: all
	erl -pa ebin -pa tmp

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
