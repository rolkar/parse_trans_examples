all: ebin/transform_parent.beam ebin/transform_child.beam ebin/parent.beam ebin/child.beam

ebin/transform_parent.beam : src/transform_parent.erl
	erlc -o ebin src/transform_parent.erl

ebin/transform_child.beam : src/transform_child.erl
	erlc -o ebin -pa ebin -pa ../parse_trans/ebin src/transform_child.erl

ebin/parent.beam : src/parent.erl ebin/transform_parent.beam
	erlc -o ebin -pa ebin -pa ../parse_trans/ebin -o ebin src/parent.erl

ebin/child.beam : src/child.erl ebin/parent.beam ebin/transform_child.beam
	erlc -o ebin -pa ebin -pa ../parse_trans/ebin src/child.erl

start: all
	erl -pa ebin

test: all
	erl -pa ebin -eval "child:foo(), halt()."

clean:
	-rm ebin/*.beam
	-rm *~ src/*~ include/*~
