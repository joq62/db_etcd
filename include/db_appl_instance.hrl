-define(TABLE,appl_instance).
-define(RECORD,?TABLE).
-record(?RECORD,{
		 instance_id,
		 appl_spec,
		 cluster_instance,
		 pod_node,
		 status
		}).


