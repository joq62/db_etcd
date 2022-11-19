-module(db_appl_deployment).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("db_appl_deployment.hrl").

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

create(SpecId,ApplName,Vsn,NumInstances,Affinity)->
    Record=#?RECORD{
		    spec_id=SpecId,
		    appl_name=ApplName,
		    vsn=Vsn,
		    num_instances=NumInstances,
		    affinity=Affinity
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
	       {_SpecId,ApplName,Vsn,NumInstances,Affinity} ->
		   case  Key of
		        appl_name->
			   {ok,ApplName};
		       vsn->
			   {ok,Vsn};
		       num_instances->
			   {ok,NumInstances};
		       affinity->
			   {ok,Affinity};
		       Err ->
			   {error,['Key eexists',Key,SpecId,?MODULE,?LINE]}
		   end
	   end,
    Return.


get_all_id()->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    [SpecId||{?RECORD,SpecId,_ApplName,_Vsn,_NumInstances,_Affinity}<-Z].
    
read_all() ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    [{SpecId,ApplName,Vsn,NumInstances,Affinity}||{?RECORD,SpecId,ApplName,Vsn,NumInstances,Affinity}<-Z].

read(Object)->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),		
		     X#?RECORD.spec_id==Object])),
    Result=case Z of
	       []->
		  [];
	       _->
		   [Info]=[{SpecId,ApplName,Vsn,NumInstances,Affinity}||{?RECORD,SpecId,ApplName,Vsn,NumInstances,Affinity}<-Z],
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
    from_file(?ApplDeploymentDir).

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
	       {ok,[{appl_deployment,SpecId,Info}]}->
		   {appl_name,ApplName}=lists:keyfind(appl_name,1,Info),
		   {vsn,Vsn}=lists:keyfind(vsn,1,Info),
		   {num_instances,NumInstances}=lists:keyfind(num_instances,1,Info),
		   {affinity,Affinity}=lists:keyfind(affinity,1,Info),
		   case create(SpecId,ApplName,Vsn,NumInstances,Affinity) of
		       {atomic,ok}->
			   [{ok,FileName}|Acc];
		       {error,Reason}->
			   [{error,[Reason,FileName,Dir,?MODULE,?LINE]}|Acc]
		   end;
	       {ok,NotAnApplSpecFile} -> 
		   [{error,[not_appl_spec_file,NotAnApplSpecFile,FileName,Dir,?MODULE,?LINE]}|Acc]
	   end,
    from_file(T,Dir,NewAcc).
			   
		   
