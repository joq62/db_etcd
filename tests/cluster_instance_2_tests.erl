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
-module(cluster_instance_2_tests).      
 
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
   
    ok=db_cluster_instance:create_table(),

    

    ClusterSpec="c200_c201",
 %   InstanceId=erlang:integer_to_list(os:system_time(microsecond),36),
    InstanceId=instance_id_1,
    PodName1=pod_name_1,
    PodNode1=pod_node_1,
    PodDir1=pod_dir_1,
    HostSpec1="c200",
    Status1=candidate,

    {atomic,ok}=db_cluster_instance:create(InstanceId,ClusterSpec,PodName1,PodNode1,PodDir1,HostSpec1,Status1),
    
    [
     {instance_id_1,"c200_c201",
      pod_name_1,pod_node_1,pod_dir_1,
      "c200",
      candidate
     }
    ]=db_cluster_instance:read(InstanceId),
     
    PodName2=pod_name_2,
    PodNode2=pod_node_2,
    PodDir2=pod_dir_2,
    HostSpec2="c201",
    Status2=deployed,

    {atomic,ok}=db_cluster_instance:create(InstanceId,ClusterSpec,PodName2,PodNode2,PodDir2,HostSpec2,Status2),
  
    [
     {instance_id_1,"c200_c201",pod_name_1,pod_node_1,pod_dir_1,"c200",candidate},
     {instance_id_1,"c200_c201",pod_name_2,pod_node_2,pod_dir_2,"c201",deployed}
    ]=db_cluster_instance:read(InstanceId),
    
    

    Spec=glurk,
    {Spec,"cookie_c200_c201",
     Spec,2,["c200","c201"],6,["c200","c201"]}=db_cluster_spec:read("c200_c201"),
    
    {ok,"cookie_c200_c201"}=db_cluster_instance:read(cookie,kuk),
    {ok,Spec}=db_cluster_spec:read(dir,Spec),
    {ok,2}=db_cluster_spec:read(num_controllers,Spec),
    {ok,["c200","c201"]}=db_cluster_spec:read(controller_host_specs,Spec),
    {ok,6}=db_cluster_spec:read(num_workers,Spec),
    {ok,["c200","c201"]}=db_cluster_spec:read(worker_host_specs,Spec),
  
    {error,[eexist,"glurk",db_cluster_spec,_]}=db_cluster_spec:read(cookie,"glurk"),
    {error,['Key eexists',glurk,"c200_c201",db_cluster_spec,_]}=db_cluster_spec:read(glurk,Spec),
 
      
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
