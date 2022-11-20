-define(ClusterDeploymentDir,"cluster_deployments").
-define(GitPathClusterDeployments,"https://github.com/joq62/cluster_deployments.git").

-define(TABLE,cluster_deployment).
-define(RECORD,?TABLE).
-record(?RECORD,{
		 spec_id,
		 cookie,
		 dir,
		 num_controllers,
		 controller_hosts,
		 num_workers,
		 worker_hosts
		}).
