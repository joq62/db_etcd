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
-module(host_spec_tests).      
 
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
    
    AllHosts=lists:sort(db_host_spec:get_all_id()),
    true=lists:member("c50",AllHosts),

   {"c50","c50","192.168.1.50",22,"joq62","festum01",[]}=db_host_spec:read("c50"),
    
    {ok,"c50"}=db_host_spec:read(hostname,"c50"),
    {ok,"192.168.1.50"}=db_host_spec:read(local_ip,"c50"),
    {ok,22}=db_host_spec:read(ssh_port,"c50"),
    {ok,"joq62"}=db_host_spec:read(uid,"c50"),
    {ok,"festum01"}=db_host_spec:read(passwd,"c50"),
    {ok,[]}=db_host_spec:read(application_config,"c50"),
    


    {error,[eexist,"glurk",db_host_spec,_]}=db_host_spec:read(ssh_port,"glurk"),
    {error,['Key eexists',glurk,"c50",db_host_spec,_]}=db_host_spec:read(glurk,"c50"),
 
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
