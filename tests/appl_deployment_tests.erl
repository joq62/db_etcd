%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(appl_deployment_tests).      
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok=setup(),
    ok=read_specs_test(),
  
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.



%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
read_specs_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    true=lists:member("db_test",db_appl_spec:get_all_id()),
    
   {"db_test","db_dummy_application",
    "0.1.0","prototype_c201",1,["c201"]}=db_appl_deployment:read("db_test"),
    
    {ok,"db_dummy_application"}=db_appl_deployment:read(appl_spec,"db_test"),
    {ok,"0.1.0"}=db_appl_deployment:read(vsn,"db_test"),
    {ok,1}=db_appl_deployment:read(num_instances,"db_test"),
    {ok,["c201"]}=db_appl_deployment:read(affinity,"db_test"),

    {error,['Key eexists',glurk,"db_test",db_appl_deployment,_]}=db_appl_deployment:read(glurk,"db_test"),
    {error,[eexist,"glurk",db_appl_deployment,_]}=db_appl_deployment:read( vsn,"glurk"),
    
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------


setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
       
    pong=db_etcd:ping(),
    ok=db_appl_deployment:create_table(),
    
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.
