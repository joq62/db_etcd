-define(TABLE,appl_deployment).
-define(RECORD,?TABLE).
-record(?RECORD,{
		 appl_name,
		 vsn,
		 num_instances,
		 affinity
		}).
