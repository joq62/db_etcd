-define(ClusterDeploymentDir,"cluster_deployments").

-define(TABLE,cluster_deployment).
-define(RECORD,?TABLE).
-record(?RECORD,{
		 spec_id,
		 cluster_name,
		 num_controllers,
		 controller_hosts,
		 num_workers,
		 worker_hosts
		}).
