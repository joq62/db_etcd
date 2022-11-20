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
-module(cluster_deployment_tests).      
 
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
    ok=install_spec_test(),
    ok=load_spec_test(),
    ok=read_specs_test(),
  
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
install_spec_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    GitClone=db_cluster_deployment:git_clone(),
    {ok,"cluster_deployments"}=GitClone,
   
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
load_spec_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    FromFileResult=db_cluster_deployment:from_file(),
    %gl=FromFileResult,
    true=lists:member({ok,"many_nodes.deployment"},FromFileResult),

    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
read_specs_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    ["many_node","single_node"]=lists:sort(db_cluster_deployment:get_all_id()),

    {"many_node","test2",3,["c100","c200"],20,[]}=db_cluster_deployment:read("many_node"),
    
    {ok,"test2"}=db_cluster_deployment:read(cluster_name,"many_node"),
    {ok,3}=db_cluster_deployment:read(num_controllers,"many_node"),
    {ok,["c100","c200"]}=db_cluster_deployment:read(controller_hosts,"many_node"),
    {ok,20}=db_cluster_deployment:read(num_workers,"many_node"),
    {ok,[]}=db_cluster_deployment:read( worker_hosts,"many_node"),
  

    {ok,2}=db_cluster_deployment:read(num_controllers,"single_node"),

    {error,[eexist,"glurk",db_cluster_deployment,_]}=db_cluster_deployment:read(cluster_name,"glurk"),
    {error,['Key eexists',glurk,"single_node",db_cluster_deployment,_]}=db_cluster_deployment:read(glurk,"single_node"),
 
    {"single_node","test1",2,[],6,[]}=db_cluster_deployment:read("single_node"),
    
    
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
    ok=db_cluster_deployment:create_table(),
    
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.
