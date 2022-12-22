%%% @author c50 <joq62@c50>
%%% @copyright (C) 2022, c50
%%% @doc
%%%
%%% @end
%%% Created : 21 Dec 2022 by c50 <joq62@c50>

-module(db_pod_desired_state).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("stdlib/include/qlc.hrl").
-include("db_pod_desired_state.hrl").

%% External exports
-export([create_table/0,create_table/2,add_node/2]).
-export([create/6,delete/1]).
-export([read_all/0,read/1,read/2,get_all_id/0]).
-export([do/1]).
-export([member/1]).
-export([]).


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

create(ParentNode,NodeName,PodDir,PaArgs,CommonFunsPaArgs,EnvArgs)->
    Record=#?RECORD{
		    parent_node=ParentNode,
		    node_name=NodeName,
		    pod_dir=PodDir,
		    pa_args=PaArgs,
		    common_funs_pa_args=CommonFunsPaArgs,
		    env_args=EnvArgs		   
		   },
    F = fun() -> mnesia:write(Record) end,
    mnesia:transaction(F).

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
delete(ParentNode) ->
    F = fun() ->
                mnesia:delete({?TABLE,ParentNode})
        end,
    mnesia:transaction(F).

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

member(PodNode)->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),		
		     X#?RECORD.pod_node==PodNode])),
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

read(Key,PodNode)->
    Return=case read(PodNode) of
	       []->
		   {error,[eexist,PodNode,?MODULE,?LINE]};
	       {PodNode,NodeName,PodDir,ParentNode,PaArgs,CommonFunsPaArgs,EnvArgs} ->
		   case  Key of
		       pod_node->
			   {ok,PodNode};
		       node_name->
			   {ok,NodeName};
		       pod_dir->
			   {ok,PodDir};
		      parent_node->
			   {ok,ParentNode};
		       pa_args->
			   {ok,PaArgs};
		       common_funs_pa_args->
			   {ok,CommonFunsPaArgs};
		       env_args->
			   {ok,EnvArgs};
		       Err ->
			   {error,['Key eexists',Err,PodNode,?MODULE,?LINE]}
		   end
	   end,
    Return.


get_all_id()->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    [R#?RECORD.pod_node||R<-Z].
    
read_all() ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    [{R#?RECORD.pod_node,R#?RECORD.node_name,R#?RECORD.pod_dir,R#?RECORD.parent_node,
      R#?RECORD.pa_args,R#?RECORD.common_funs_pa_args,R#?RECORD.env_args}||R<-Z].

read(ParentNode)->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),		
		     X#?RECORD.parent_node==ParentNode])),
    Result=case Z of
	       []->
		  [];
	       _->
		   [Info]=[{R#?RECORD.pod_node,R#?RECORD.node_name,R#?RECORD.pod_dir,R#?RECORD.parent_node,
			    R#?RECORD.pa_args,R#?RECORD.common_funs_pa_args,R#?RECORD.env_args}||R<-Z],
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
