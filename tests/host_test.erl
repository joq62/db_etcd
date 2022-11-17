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
-module(host_test).      
 
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
    ok=init_tests(),
    ok=read_tests(),
   
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
 %   timer:sleep(2000),
 %   init:stop(),
    ok.


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
read_tests()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    true=db_host_spec:member("c100"),
    false=db_host_spec:member("glurk"),
    {ok,"192.168.1.100"}=db_host_spec:read(local_ip,"c100"),
    {ok,"192.168.1.200"}=db_host_spec:read(local_ip,"c200"),
    {ok,"public.com"}=db_host_spec:read(public_ip,"c100"),
    {ok,22}=db_host_spec:read(ssh_port,"c100"),
    {ok,uid100 }=db_host_spec:read(uid,"c100"),
    {ok,passwd200}=db_host_spec:read(passwd,"c200"),
    {ok,[]}=db_host_spec:read(application_config,"c100"),
    {error,['Key eexists',glurk,read,db_host_spec,_]}=db_host_spec:read(glurk,"c100"),   
    
      
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
init_tests()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    ok=db_host_spec:create_table(),
    
   % db_host_spec:create(HostName,LocalIp,PublicIp,SshPort,Uid,Passwd,ApplicationConfig),
    {atomic,ok}=db_host_spec:create("c100","192.168.1.100","public.com",22,uid100,passwd100,[]),
    {atomic,ok}=db_host_spec:create("c200","192.168.1.200","public.com",22,uid200,passwd200,[]),
    
    
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


setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    pong=db_etcd:ping(),
    
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.
