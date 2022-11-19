-define(TABLE,appl_state).
-define(RECORD,?TABLE).
-record(?RECORD,{
		 name,
		 deployment_id,   %u
		 pods,           %{Node,PodDir,HostName}
		 deployment_time %{date(),time()}
		}).
