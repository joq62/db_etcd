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
-module(cluster_deployment_2_tests).      
 
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
    
    ["single_c100"]=lists:sort(db_cluster_deployment:get_all_id()),

    {"single_c100",
     "cookie_single_c100",
     "single_c100",1,["c100"],6,["c100"]}=db_cluster_deployment:read("single_c100"),
    
    {ok,"cookie_single_c100"}=db_cluster_deployment:read(cookie,"single_c100"),
    {ok,"single_c100"}=db_cluster_deployment:read(dir,"single_c100"),
    {ok,1}=db_cluster_deployment:read(num_controllers,"single_c100"),
    {ok,["c100"]}=db_cluster_deployment:read(controller_hosts,"single_c100"),
    {ok,6}=db_cluster_deployment:read(num_workers,"single_c100"),
    {ok,["c100"]}=db_cluster_deployment:read( worker_hosts,"single_c100"),
  

    {error,[eexist,"glurk",db_cluster_deployment,_]}=db_cluster_deployment:read(cluster_name,"glurk"),
    {error,['Key eexists',glurk,"single_c100",db_cluster_deployment,_]}=db_cluster_deployment:read(glurk,"single_c100"),
 
    
    
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
