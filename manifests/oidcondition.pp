define snmpcollector::oidcondition(
		$ensure = 'present',
		Boolean $is_multiple = false,
		String $condition,
		String $condition_type,
		String $condition_value,
		String $description = "MANAGED BY PUPPET"
) 
{
	include snmpcollector::reload

	#TODO: a bunch of validation here.

	snmpcollector_oidcondition { $title :
		ensure => $ensure,
		is_multiple => $is_multiple,
		condition => $condition,
		condition_type => $condition_type,
		condition_value => $condition_value,
		description => $description
	} ~> Class['snmpcollector::reload']
}