all:
	rm -rf  *~ */*~ src/*.beam tests/*.beam tests_ebin erl_cra*;
	rm -rf _build logs log *.pod_dir;
	rm -rf _build tests_ebin ebin;
	rm -rf Mnesia.*;
	rm -rf *.dir;
	rm -f rebar.lock;
#	tests 
	mkdir tests_ebin;
	erlc -I include -o tests_ebin tests/*.erl;
#  	dependencies
	rm -f rebar.config;
	cp tests/rebar.config_release rebar.config;
	mkdir ebin;
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build*;
	git add -f *;
	git commit -m $(m);
	git push;
	echo Ok there you go!
build:
	rm -rf  *~ */*~ src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf _build logs log *.pod_dir;
	rm -rf deployments *_info_specs;
	rm -rf _build test_ebin ebin;
	rm -f rebar.config;
	cp tests/rebar.config_release rebar.config;
	mkdir ebin;		
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build test_ebin logs log;


clean:
	rm -rf  *~ */*~ src/*.beam tests/*.beam
	rm -rf erl_cra*;
	rm -rf spec.*;
	rm -rf tests_ebin
	rm -rf ebin;
	rm -rf Mnesia.*;
	rm -rf *.dir;

eunit:
	rm -rf  *~ */*~ src/*.beam tests/*.beam
	rm -rf erl_cra*;
#	rm -rf  application_specs cluster_specs host_specs;
#	rm -rf  application_deployments cluster_deployments;	
	rm -rf tests_ebin
	rm -rf ebin;
	rm -rf Mnesia.*;
	rm -rf *.dir;
	rm -f rebar.lock;
#	tests 
	mkdir tests_ebin;
	erlc -I include -o tests_ebin tests/*.erl;
#  	dependencies
	rm -f rebar.config;
	cp tests/rebar.config_test rebar.config;
	mkdir ebin;		
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build*;
	erl -pa * -pa ebin -pa tests_ebin -sname db_etcd_test -run $(m) start -setcookie db_etcd
