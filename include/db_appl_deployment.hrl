-define(ApplDeploymentDir,"application_deployments").

-define(TABLE,appl_deployment).
-define(RECORD,?TABLE).
-record(?RECORD,{
		 spec_id,
		 appl_name,
		 vsn,
		 num_instances,
		 affinity
		}).
