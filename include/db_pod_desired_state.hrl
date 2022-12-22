-define(TABLE,pod_desired_state).
-define(RECORD,?TABLE).
-record(?RECORD,{
		 pod_node,
		 node_name,
		 pod_dir,
		 parent_node,
		 pa_args,
		 common_funs_pa_args,
		 env_args
		 
		}).


