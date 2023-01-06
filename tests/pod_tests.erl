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
-module(pod_tests).      
 
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
     '1_c200_c201_pod@c200','1_c200_c201_pod@c201','1_c200_pod@c200','1_c201_pod@c201',
     '2_c200_c201_pod@c200','2_c200_c201_pod@c201','2_c200_pod@c200','2_c201_pod@c201',
     '3_c200_c201_pod@c200','3_c200_c201_pod@c201','3_c200_pod@c200','3_c201_pod@c201',
     '4_c200_c201_pod@c200','4_c200_c201_pod@c201',
     '5_c200_c201_pod@c200','5_c200_c201_pod@c201',
     '6_c200_c201_pod@c200','6_c200_c201_pod@c201'
    ]=lists:sort(db_pod_desired_state:get_all_id()),

    Pod='1_c200_c201_pod@c200',

    {
     '1_c200_c201_pod@c200',"1_c200_c201_pod","c200_c201/1_c200_c201_pod",
     'c200_c201_parent@c200',[]," "
    }=db_pod_desired_state:read(Pod),
    
    {ok,Pod}=db_pod_desired_state:read(pod_node,Pod),
    {ok,"1_c200_c201_pod"}=db_pod_desired_state:read(node_name,Pod),
    {ok,"c200_c201/1_c200_c201_pod"}=db_pod_desired_state:read(pod_dir,Pod),
    {ok,'c200_c201_parent@c200'}=db_pod_desired_state:read(parent_node,Pod),
    {ok,[]}=db_pod_desired_state:read(pa_args_list,Pod),
    {ok," "}=db_pod_desired_state:read(env_args,Pod),
    
    

    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
create_wanted_stat_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
   
    %% Parent desired state is pre-requesite for pod waned state 
    AllClusterSpecs=db_cluster_spec:get_all_id(),
    ok=db_parent_desired_state:create_table(),
    []=[{error,Reason}||{error,Reason}<-[lib_parent:load_desired_state(ClusterSpec)||ClusterSpec<-AllClusterSpecs]],

    %% Create Pod
    ok=db_pod_desired_state:create_table(),
    R=[lib_pod:load_desired_state(ClusterSpec)||ClusterSpec<-AllClusterSpecs],
    []=[{error,Reason}||{error,Reason}<-R],

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
