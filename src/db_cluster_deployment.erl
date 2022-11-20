-module(db_cluster_deployment).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("db_cluster_deployment.hrl").

create_table()->
    mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)}
				]),
    mnesia:wait_for_tables([?TABLE], 20000).

create_table(NodeList,StorageType)->
    mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)},
				 {StorageType,NodeList}]),
    mnesia:wait_for_tables([?TABLE], 20000).

add_node(Node,StorageType)->
    Result=case mnesia:change_config(extra_db_nodes, [Node]) of
	       {ok,[Node]}->
		   mnesia:add_table_copy(schema, node(),StorageType),
		   mnesia:add_table_copy(?TABLE, node(), StorageType),
		   Tables=mnesia:system_info(tables),
		   mnesia:wait_for_tables(Tables,20*1000);
	       Reason ->
		   Reason
	   end,
    Result.

create(SpecId,ClusterName,NumControllers,ControllerHosts,NumWorkers,WorkerHosts)->
    Record=#?RECORD{
		    spec_id=SpecId,
		    cluster_name=ClusterName,
		    num_controllers=NumControllers,
		    controller_hosts=ControllerHosts,
		    num_workers=NumWorkers,
		    worker_hosts=WorkerHosts
		   },
    F = fun() -> mnesia:write(Record) end,
    mnesia:transaction(F).

member(SpecId)->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),		
		     X#?RECORD.spec_id==SpecId])),
    Member=case Z of
	       []->
		   false;
	       _->
		   true
	   end,
    Member.

read(Key,SpecId)->
    Return=case read(SpecId) of
	       []->
		   {error,[eexist,SpecId,?MODULE,?LINE]};
	       {_SpecId,ClusterName,NumControllers,ControllerHosts,NumWorkers,WorkerHosts} ->
		   case  Key of
		       cluster_name->
			   {ok,ClusterName};
		       num_controllers->
			   {ok,NumControllers};
		       controller_hosts->
			   {ok,ControllerHosts};
		       num_workers->
			   {ok,NumWorkers};
		       worker_hosts->
			   {ok,WorkerHosts};
		       Err ->
			   {error,['Key eexists',Key,SpecId,?MODULE,?LINE]}
		   end
	   end,
    Return.


get_all_id()->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    [SpecId||{?RECORD,SpecId,_ClusterName,_NumControllers,_ControllerHosts,_NumWorkers,_WorkerHosts}<-Z].
    
read_all() ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    [{SpecId,ClusterName,NumControllers,ControllerHosts,NumWorkers,WorkerHosts}||{?RECORD,SpecId,ClusterName,NumControllers,ControllerHosts,NumWorkers,WorkerHosts}<-Z].

read(Object)->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),		
		     X#?RECORD.spec_id==Object])),
    Result=case Z of
	       []->
		  [];
	       _->
		   [Info]=[{SpecId,ClusterName,NumControllers,ControllerHosts,NumWorkers,WorkerHosts}||{?RECORD,SpecId,ClusterName,NumControllers,ControllerHosts,NumWorkers,WorkerHosts}<-Z],
		   Info
	   end,
    Result.

delete(Object) ->
    F = fun() -> 
		mnesia:delete({?TABLE,Object})
		    
	end,
    mnesia:transaction(F).


do(Q) ->
    F = fun() -> qlc:e(Q) end,
    Result=case mnesia:transaction(F) of
	       {atomic, Val} ->
		   Val;
	       {error,Reason}->
		   {error,Reason}
	   end,
    Result.

%%-------------------------------------------------------------------------
from_file()->
    from_file(?ClusterDeploymentDir).

from_file(Dir)->
    {ok,FileNames}=file:list_dir(Dir),
    from_file(FileNames,Dir,[]).

from_file([],_,Acc)->
    Acc;		     
from_file([FileName|T],Dir,Acc)->
    FullFileName=filename:join(Dir,FileName),
    NewAcc=case file:consult(FullFileName) of
	       {error,Reason}->
		   [{error,[Reason,FileName,Dir,?MODULE,?LINE]}|Acc];
	       {ok,[{cluster_deployment,SpecId,Info}]}->
		   {cluster_name,ClusterName}=lists:keyfind(cluster_name,1,Info),
		   {num_controllers,NumControllers}=lists:keyfind(num_controllers,1,Info),
		   {controller_hosts,ControllerHosts}=lists:keyfind(controller_hosts,1,Info),
		   {num_workers,NumWorkers}=lists:keyfind(num_workers,1,Info),
		   {worker_hosts,WorkerHosts}=lists:keyfind(worker_hosts,1,Info),
		   case create(SpecId,ClusterName,NumControllers,ControllerHosts,NumWorkers,WorkerHosts) of
		       {atomic,ok}->
			   [{ok,FileName}|Acc];
		       {error,Reason}->
			   [{error,[Reason,FileName,Dir,?MODULE,?LINE]}|Acc]
		   end;
	       {ok,NotAnApplSpecFile} -> 
		   [{error,[not_appl_spec_file,NotAnApplSpecFile,FileName,Dir,?MODULE,?LINE]}|Acc]
	   end,
    from_file(T,Dir,NewAcc).
	
  
