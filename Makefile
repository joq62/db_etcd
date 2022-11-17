all:
	rm -rf  *~ */*~ src/*.beam tests/*.beam tests_ebin erl_cra*;
	rm -rf _build logs log *.pod_dir;
	rm -rf _build tests_ebin ebin;
	rm -rf spec.*;
	rm -rf Mnesia.*;
	mkdir ebin;
	erlc -I include -o ebin src/*.erl;		
	rm -rf ebin;
	git add *;
	git commit -m $(m);
	git push;
	echo Ok there you go!
build:
	rm -rf  *~ */*~ src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf _build logs log *.pod_dir;
	rm -rf deployments *_info_specs;
	rm -rf _build test_ebin ebin;
	mkdir ebin;		
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build test_ebin logs log;


clean:
	rm -rf  *~ */*~ src/*.beam tests/*.beam
	rm -rf erl_cra*;
	rm -rf tests_ebin
	rm -rf ebin;
	rm -rf Mnesia.*

eunit:
	rm -rf  *~ */*~ src/*.beam tests/*.beam
	rm -rf erl_cra*;
	rm -rf tests_ebin
	rm -rf ebin;
	rm -rf Mnesia.*
#	tests 
	mkdir tests_ebin;
	erlc -I include -o tests_ebin tests/*.erl;
#  	dependencies
	erlc -I include -o tests_ebin ../../infra_services/common/src/*.erl;
#	application
	mkdir ebin;
	erlc -I include -o ebin src/*.erl;	
	erl -pa * -pa ebin -pa tests_ebin -sname db_etcd_test -run $(m) start -setcookie db_etcd
