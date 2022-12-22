%%% @author c50 <joq62@c50>
%%% @copyright (C) 2022, c50
%%% @doc
%%%
%%% @end
%%% Created : 21 Dec 2022 by c50 <joq62@c50>

-module(db_parent_desired_state).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("stdlib/include/qlc.hrl").
-include("db_parent_desired_state.hrl").

%% External exports
-export([create_table/0,create_table/2,add_node/2]).
-export([create/7,delete/1]).
-export([read_all/0,read/1,read/2,get_all_id/0]).
-export([do/1]).
-export([member/1]).
-export([git_clone_load/0]).


%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

create_table()->
    mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)}
				]),
    mnesia:wait_for_tables([?TABLE], 20000).

create_table(NodeList,StorageType)->
    mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)},
				 {StorageType,NodeList}]),
    mnesia:wait_for_tables([?TABLE], 20000).

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

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

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

create(ClusterSpec,Cookie,ClusterDir,NumControllers,ControllerHostSpecs,NumWorkers,WorkerHostSpecs)->
    Record=#?RECORD{
		    spec_id=ClusterSpec,
		    cookie=Cookie,
		    dir=ClusterDir,
		    num_controllers=NumControllers,
		    controller_host_specs=ControllerHostSpecs,
		    num_workers=NumWorkers,
		    worker_host_specs=WorkerHostSpecs
		   },
    F = fun() -> mnesia:write(Record) end,
    mnesia:transaction(F).

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
delete(Object) ->
    F = fun() ->
                mnesia:delete({?TABLE,Object})

        end,
    mnesia:transaction(F).

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

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


%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

read(Key,SpecId)->
    Return=case read(SpecId) of
	       []->
		   {error,[eexist,SpecId,?MODULE,?LINE]};
	       {_SpecId,Cookie,ClusterDir,NumControllers,ControllerHostSpecs,NumWorkers,WorkerHostSpecs} ->
		   case  Key of
		      cookie->
			   {ok,Cookie};
		       dir->
			   {ok,ClusterDir};
		       num_controllers->
			   {ok,NumControllers};
		       controller_host_specs->
			   {ok,ControllerHostSpecs};
		       num_workers->
			   {ok,NumWorkers};
		       worker_host_specs->
			   {ok,WorkerHostSpecs};
		       Err ->
			   {error,['Key eexists',Err,SpecId,?MODULE,?LINE]}
		   end
	   end,
    Return.


get_all_id()->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    [SpecId||{?RECORD,SpecId,_Cookie,_ClusterDir,_NumControllers,_ControllerHostSpecs,_NumWorkers,_WorkerHostSpecs}<-Z].
    
read_all() ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    [{SpecId,Cookie,ClusterDir,NumControllers,ControllerHostSpecs,NumWorkers,WorkerHostSpecs}||{?RECORD,SpecId,Cookie,ClusterDir,NumControllers,ControllerHostSpecs,NumWorkers,WorkerHostSpecs}<-Z].

read(Object)->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),		
		     X#?RECORD.spec_id==Object])),
    Result=case Z of
	       []->
		  [];
	       _->
		   [Info]=[{SpecId,Cookie,ClusterDir,NumControllers,ControllerHostSpecs,NumWorkers,WorkerHostSpecs}||{?RECORD,SpecId,Cookie,ClusterDir,NumControllers,ControllerHostSpecs,NumWorkers,WorkerHostSpecs}<-Z],
		   Info
	   end,
    Result.

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

do(Q) ->
    F = fun() -> qlc:e(Q) end,
    Result=case mnesia:transaction(F) of
	       {atomic, Val} ->
		   Val;
	       {error,Reason}->
		   {error,Reason}
	   end,
    Result.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

git_clone_load()->
    ok=create_table(),
    Result=case git_clone() of
	       {error,Reason}->
		   {error,Reason};
	       {ok,TempDirName,SpecDir}->
		   case from_file(SpecDir) of
		       {error,Reason}->
			   file:del_dir_r(TempDirName),	
			   {error,Reason};
		       LoadResult->
			   file:del_dir_r(TempDirName),		
			   LoadResult
		   end
	   end,
    Result.

git_clone()->
    TempDirName=erlang:integer_to_list(os:system_time(microsecond),36)++".dir",
    ok=file:make_dir(TempDirName),
    true=filelib:is_dir(TempDirName),

    GitDir=filename:join(TempDirName,?ClusterSpecDir),
    ok=file:make_dir(GitDir),
    GitPath=?GitPathClusterSpecs,
    {ok,GitResult}=cmn_appl:git_clone_to_dir(node(),GitPath,GitDir),
     Result=case filelib:is_dir(GitDir) of
	       false->
		   {error,[failed_to_clone,GitPath,GitResult]};
	       true->
		   {ok,TempDirName,GitDir}
	   end,
    Result.	

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
	       {ok,[{cluster_spec,SpecId,Info}]}->
		   {cookie,Cookie}=lists:keyfind(cookie,1,Info),
		   {dir,ClusterDir}=lists:keyfind(dir,1,Info),
		   {num_controllers,NumControllers}=lists:keyfind(num_controllers,1,Info),
		   {controller_host_specs,ControllerHostSpecs}=lists:keyfind(controller_host_specs,1,Info),
		   {num_workers,NumWorkers}=lists:keyfind(num_workers,1,Info),
		   {worker_host_specs,WorkerHostSpecs}=lists:keyfind(worker_host_specs,1,Info),
		   case create(ParentNode,RootDir,NodeName,ClusterSpec,HostSpecCookie,ClusterDir,NumControllers,ControllerHostSpecs,NumWorkers,WorkerHostSpecs) of
		       {atomic,ok}->
			   [{ok,FileName}|Acc];
		       {error,Reason}->
			   [{error,[Reason,FileName,Dir,?MODULE,?LINE]}|Acc]
		   end;
	       {ok,NotAnApplSpecFile} -> 
		   [{error,[not_appl_spec_file,NotAnApplSpecFile,FileName,Dir,?MODULE,?LINE]}|Acc]
	   end,
 %   io:format("NewAcc ~p~n",[{NewAcc,?MODULE,?LINE}]),
    from_file(T,Dir,NewAcc).
	
  
