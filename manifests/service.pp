class snmpcollector::service ($enable = true){

	# ensure the service is running and enabled at boot.
	service { 'snmpcollector':
	  ensure => 'running',
	  enable => $enable,
	  require => Package["snmpcollector"],
	} 
}