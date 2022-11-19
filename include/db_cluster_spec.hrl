-define(ClusterSpecDir,"cluster_specs").

-define(TABLE,cluster_spec).
-define(RECORD,?TABLE).
-record(?RECORD,{
		 spec_id,
		 cluster_name,
		 cookie
		}).
