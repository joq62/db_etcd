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
-module(appl_instance_2_tests).      
 
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
    ok=create_instance_test(),
  
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.



%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
create_instance_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
   
    ok=db_appl_instance:create_table(),
    
    

    InstanceId=instance_id_1,
    ApplSpec1="appl_spec_1",
    ClusterInstance1=cluster_instance_id_1,
    PodNode1=pod_node_1,
    Status1=candidate,

    {atomic,ok}=db_appl_instance:create(InstanceId,ApplSpec1,ClusterInstance1,PodNode1,Status1),
    
    [{instance_id_1,"appl_spec_1",cluster_instance_id_1,pod_node_1,candidate}]=db_appl_instance:read(InstanceId),
 
    
    ApplSpec2="appl_spec_2",
    ClusterInstance2=cluster_instance_id_2,
    PodNode2=pod_node_2,
    Status2=deployed,

    {atomic,ok}=db_appl_instance:create(InstanceId,ApplSpec2,ClusterInstance2,PodNode2,Status2),
  
   [
    {instance_id_1,"appl_spec_1",cluster_instance_id_1,pod_node_1,candidate},
    {instance_id_1,"appl_spec_2",cluster_instance_id_2,pod_node_2,deployed}
   ]=db_appl_instance:read(InstanceId),
    
    

    {ok,"appl_spec_1"}=db_appl_instance:read(appl_spec,InstanceId,PodNode1),
    {ok,"appl_spec_2"}=db_appl_instance:read(appl_spec,InstanceId,PodNode2),
    {ok,cluster_instance_id_1}=db_appl_instance:read(cluster_instance,InstanceId,PodNode1),
    {ok,cluster_instance_id_2}=db_appl_instance:read(cluster_instance,InstanceId,PodNode2),
    {ok,candidate}=db_appl_instance:read(status,InstanceId,PodNode1),
  
    []=db_appl_instance:read(status,InstanceId,glurk),
    {error,['Key eexists',glurk,instance_id_1,db_appl_instance,_]}=db_appl_instance:read(glurk,InstanceId,PodNode1),
 
      
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
