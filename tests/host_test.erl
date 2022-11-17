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
  %  ok=init_tests(),
    ok=read_specs_test(),

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
read_specs_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    
    CreateResult=lists:sort(host_spec:init_table(node())),    
    [{"c100",{atomic,ok}},
     {"c200",{atomic,ok}},
     {"c201",{atomic,ok}},
     {"c202",{atomic,ok}},
     {"c300",{atomic,ok}}]=CreateResult,

    AllIp=[{HostName,db_host_spec:read(local_ip,HostName)}||HostName<-host_spec:all_names()],
    [{"c100",{ok,"192.168.1.100"}},
     {"c200",{ok,"192.168.1.200"}},
     {"c201",{ok,"192.168.1.201"}},
     {"c202",{ok,"192.168.1.202"}},
     {"c300",{ok,"192.168.1.230"}}]=AllIp,
    
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
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
    {ok,"joqhome.asuscomm.com"}=db_host_spec:read(public_ip,"c100"),
    {ok,22}=db_host_spec:read(ssh_port,"c100"),
    {ok,_ }=db_host_spec:read(uid,"c100"),
    {ok,_}=db_host_spec:read(passwd,"c200"),
    {ok,[]}=db_host_spec:read(application_config,"c200"),
    {error,['Key eexists',glurk,read,db_host_spec,_]}=db_host_spec:read(glurk,"c100"),   
    
      
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


setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    pong=db_etcd:ping(),
    ok=db_host_spec:create_table(),
    
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.
