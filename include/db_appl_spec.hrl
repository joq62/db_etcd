-define(ApplSpecDir,"application_specs").

-define(TABLE,application_spec).
-define(RECORD,application_spec).
-record(?RECORD,{
		 spec_id,
		 appl_name,
		 vsn,
		 app,
		 gitpath
		}).
