define snmpcollector::influxserver(
		$ensure		 	= 'present',
		String $host,
		Integer $port		 	= 8086,
		String $database,
		String $username,
		String $password,
		String $retention		= 'autogen',
		String $precision		= 's',
		Integer $timeout	 	= 30,
		String $user_agent		= 'snmpcollector',
		String $description	= 'MANAGED BY PUPPET'
) 
{
	include snmpcollector::reload

	#TODO: a bunch of validation here.

	snmpcollector_influxserver { $title :
		ensure => $ensure,
		host => $host,
		port => $port,
		database => $database,
		username => $username,
		password => $password,
		retention => $retention,
		precision => $precision,
		timeout => $timeout,
		user_agent => $user_agent,
		description => $description
	} ~> Class['snmpcollector::reload']
}