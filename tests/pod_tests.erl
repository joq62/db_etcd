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
    ok=add_delete_appls_test(),

    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

add_delete_appls_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    {ok,DesiredNodes}=lib_pod:desired_nodes(),
    SortedDesiredNodes=lists:sort(DesiredNodes),
    [Pod1|_]=SortedDesiredNodes,
    Pod1='1_c200_c201_pod@c200',
    %---
    {ok,[]}=db_pod_desired_state:read(appl_spec_list,Pod1),
    []=[Pod||Pod<-SortedDesiredNodes,
	     {ok,[]}/=db_pod_desired_state:read(appl_spec_list,Pod)],

    %
    {atomic,ok}=db_pod_desired_state:add_appl_list(appl_spec_1,Pod1),
    {ok,AppSpec1}=db_pod_desired_state:read(appl_spec_list,Pod1),
    [appl_spec_1]=AppSpec1,

    {atomic,ok}=db_pod_desired_state:add_appl_list(appl_spec_2,Pod1),
    {atomic,ok}=db_pod_desired_state:add_appl_list(appl_spec_3,Pod1),
    {ok,AppSpec2}=db_pod_desired_state:read(appl_spec_list,Pod1),
    [appl_spec_1,appl_spec_2,appl_spec_3]=lists:sort(AppSpec2),

    [Pod1]=[Pod||Pod<-SortedDesiredNodes,
	   {ok,[]}/=db_pod_desired_state:read(appl_spec_list,Pod)],

    {atomic,ok}=db_pod_desired_state:delete_appl_list(appl_spec_2,Pod1),
    {ok,AppSpec3}=db_pod_desired_state:read(appl_spec_list,Pod1),
    [appl_spec_1,appl_spec_3]=lists:sort(AppSpec3),

    {atomic,ok}=db_pod_desired_state:delete_appl_list(appl_spec_1,Pod1),
    {aborted,{error,["ERROR: ApplSpec already removed to PodNode  ",appl_spec_1,'1_c200_c201_pod@c200']}}=db_pod_desired_state:delete_appl_list(appl_spec_1,Pod1),
    {atomic,ok}=db_pod_desired_state:delete_appl_list(appl_spec_3,Pod1),
    {ok,[]}=db_pod_desired_state:read(appl_spec_list,Pod1),

    
    ok.


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
read_tests()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),    
   {ok,DesiredNodes}=lib_pod:desired_nodes(), 
    SortedDesiredNodes=lists:sort(DesiredNodes),
    [Pod1|_]=SortedDesiredNodes,

    {
     '1_c200_c201_pod@c200',"1_c200_c201_pod","c200_c201/1_c200_c201_pod",
     'c200_c201_parent@c200',[],"c200_c201","c200",[]," "
    }=db_pod_desired_state:read(Pod1),
   
    {ok,'1_c200_c201_pod@c200'}=db_pod_desired_state:read(pod_node,Pod1),
    {ok,"1_c200_c201_pod"}=db_pod_desired_state:read(node_name,Pod1),
    {ok,"c200_c201/1_c200_c201_pod"}=db_pod_desired_state:read(pod_dir,Pod1),
    {ok,'c200_c201_parent@c200'}=db_pod_desired_state:read(parent_node,Pod1),
    {ok,[]}=db_pod_desired_state:read( appl_spec_list,Pod1),
    {ok,"c200_c201"}=db_pod_desired_state:read(cluster_spec,Pod1),
    {ok,"c200"}=db_pod_desired_state:read(host_spec,Pod1),
    {ok,[]}=db_pod_desired_state:read(pa_args_list,Pod1),
    {ok," "}=db_pod_desired_state:read(env_args,Pod1),
  
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
