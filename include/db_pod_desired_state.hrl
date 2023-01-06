-define(TABLE,pod_desired_state).
-define(RECORD,?TABLE).
-record(?RECORD,{
		 pod_node,
		 node_name,
		 pod_dir,
		 parent_node,
		 pa_args_list,
		 env_args
		 
		}).


