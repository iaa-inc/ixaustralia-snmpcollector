define snmpcollector::measurement_filter(
		$ensure = 'present',
		Boolean $enable_alias = true,
		String $filter_type,
		String $filter_condition,
		String $measurement
) 
{
	include snmpcollector::reload

	#TODO: a bunch of validation here.

	snmpcollector_measurement_filter { $title :
		ensure => $ensure,
		enable_alias => $enable_alias,
		filter_type => $filter_type,
		filter_name => $filter_condition,
		measurement => $measurement,
	} ~> Class['snmpcollector::reload']
}