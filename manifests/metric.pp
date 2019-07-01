define snmpcollector::metric(
		$ensure		 				= 'present',
		String $field_name, 
		String $description			= 'MANAGED BY PUPPET',
		String $base_oid,
		String $datasource_type,
		Boolean $get_rate	 		= false,
		Integer $scale		 		= 0, 
		Integer $shift		 		= 0,
		Boolean $is_tag				= false,
		String $extra_data 			= '',
		Integer $conversion			= 0
) 
{
	include snmpcollector::reload

	#TODO: a bunch of validation here.

	snmpcollector_metric { $title :
		ensure => $ensure,
		field_name => $field_name,
		description => $description,
		base_oid => $base_oid,
		datasource_type => $datasource_type,
		get_rate => $get_rate,
		scale => $scale,
		shift => $shift,
		is_tag => $is_tag,
		extra_data => $extra_data,
		conversion => $conversion
	} ~> Class['snmpcollector::reload']
}

