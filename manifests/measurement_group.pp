define snmpcollector::measurement_group(
		$ensure = 'present',
		Array $measurements,
		String $description = "MANAGED BY PUPPET"
) 
{
	include snmpcollector::reload

	#TODO: a bunch of validation here.

	snmpcollector_measurement_group { $title :
		ensure => $ensure,
		measurements => $measurements,
		description => $description,
	} ~> Class['snmpcollector::reload']
}