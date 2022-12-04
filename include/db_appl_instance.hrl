-define(TABLE,appl_instance).
-define(RECORD,?TABLE).
-record(?RECORD,{
		 instance_id,
		 app,
		 appl_spec_id,
		 cluster_spec_id,
		 cluster_instance,
		 pod_name,
		 pod_node,
		 pod_dir,
		 host_spec_id,
		 status
		}).


