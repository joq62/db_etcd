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
-module(appl_spec_tests).      
 
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
    ok=from_file_test(),
    ok=read_specs_test(),
  
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.



%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
from_file_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    FromFileResult=db_appl_spec:from_file(),
    true=lists:member({ok,"math.spec"},FromFileResult),

    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
read_specs_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    ["db_etcd","math"]=lists:sort(db_appl_spec:get_all_id()),
    
    {"math",
     "math",
     "0.1.0",
     math,
     "https://github.com/joq62/math.git"
    }=db_appl_spec:read("math"),
    
    {ok,"math"}=db_appl_spec:read(appl_name,"math"),
    {ok,"0.1.0"}=db_appl_spec:read(vsn,"math"),
    {ok,math}=db_appl_spec:read(app,"math"),
    {ok,"https://github.com/joq62/math.git"}=db_appl_spec:read(gitpath,"math"),
    {error,['Key eexists',glurk,"math",db_appl_spec,_]}=db_appl_spec:read(glurk,"math"),
    {error,[eexist,"glurk",db_appl_spec,_]}=db_appl_spec:read( vsn,"glurk"),

    {"db_etcd",
     "db_etcd",
     "0.1.0",
     db_etcd,
     "https://github.com/joq62/db_etcd.git"
    }=db_appl_spec:read("db_etcd"),
    
    
    
    
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
    ok=db_appl_spec:create_table(),
    
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    ok.
