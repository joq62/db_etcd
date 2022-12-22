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
-module(parents_tests).      
 
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
    ok=create_wanted_stat_test(),
    ok=read_tests(),
  
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
read_tests()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),    
    [
     'c200_c201_parent@c200',
     'c200_c201_parent@c201',
     'c200_parent@c200',
     'c201_parent@c201'
    ]=lists:sort(db_parent_desired_state:get_all_id()),
    Parent='c200_c201_parent@c200',
    {ok,Parent}=db_parent_desired_state:read(parent_node,Parent),
    {ok,"c200_c201_parent"}=db_parent_desired_state:read(node_name,Parent),
    {ok,"c200_c201"}=db_parent_desired_state:read(cluster_spec,Parent),
    {ok,"c200"}=db_parent_desired_state:read(host_spec,Parent),
    {ok," -pa c200_c201 "}=db_parent_desired_state:read(root_pa_args,Parent),
    {ok," -pa c200_c201/*/ebin"}=db_parent_desired_state:read(common_funs_pa_args,Parent),
    {ok," "}=db_parent_desired_state:read( env_args,Parent),
    
    

    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
create_wanted_stat_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
   
    AllClusterSpecs=db_cluster_spec:get_all_id(),
    ok=db_parent_desired_state:create_table(),

    R=[lib_parent:load_desired_state(ClusterSpec)||ClusterSpec<-AllClusterSpecs],
    []=[{error,Reason}||{error,Reason}<-R],
    
    [
     {'c200_c201_parent@c200',"c200_c201_parent","c200_c201","c200",
      " -pa c200_c201 "," -pa c200_c201/*/ebin"," "},
     {'c200_c201_parent@c201',"c200_c201_parent","c200_c201","c201",
      " -pa c200_c201 "," -pa c200_c201/*/ebin"," "},
     {'c200_parent@c200',"c200_parent","c200","c200",
      " -pa c200 "," -pa c200/*/ebin"," "},
     {'c201_parent@c201',"c201_parent","c201","c201",
      " -pa c201 "," -pa c201/*/ebin"," "}
    ]=lists:keysort(1,db_parent_desired_state:read_all()),
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
    
    ok.
