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
-module(appl_tests).      
 
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
 
  
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
create_wanted_stat_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
   
    %% Parent desired state is pre-requesite for pod waned state 
    AllClusterSpecs=lists:sort(db_cluster_spec:get_all_id()),
 

    {ok,_}=pod_server:start(),
    pong=pod_server:ping(),
    R=[{ClusterSpec,pod_server:load_desired_state(ClusterSpec)}||ClusterSpec<-AllClusterSpecs,
								 ClusterSpec=="c200_c201"],
    io:format("R ~p~n",[{R,?MODULE,?FUNCTION_NAME}]),
    
    %% Create appl
    R=[lib_appl:load_desired_state(ClusterSpec)||ClusterSpec<-AllClusterSpecs],
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
