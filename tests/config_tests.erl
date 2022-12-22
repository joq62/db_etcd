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
-module(config_tests).      
 
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
    ok=unit_1_test(),
  
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
unit_1_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    [{key_dummy,value_dummy}]=lists:sort(db_config:get_all()),
    {atomic,ok}=db_config:set(key1,value1),
    [{key1,value1},{key_dummy,value_dummy}]=lists:sort(db_config:get_all()),
    {atomic,ok}=db_config:set(key2,value1),
    [{key1,value1},{key2,value1},{key_dummy,value_dummy}]=lists:sort(db_config:get_all()),
    value1=db_config:get(key1),
    value1=db_config:get(key2),
    {atomic,ok}=db_config:set(key1,value2),
    [{key1,value2},{key2,value1},{key_dummy,value_dummy}]=lists:sort(db_config:get_all()),
    value2=db_config:get(key1),
    value1=db_config:get(key2),

    {atomic,ok}=db_config:delete(key1),
    [{key2,value1},{key_dummy,value_dummy}]=lists:sort(db_config:get_all()),
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
    
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.
