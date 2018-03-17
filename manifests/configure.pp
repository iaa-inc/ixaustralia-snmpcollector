class snmpcollector::configure (
	String $instance_name,
	Integer $web_port,
	String $admin_username,
	String $admin_password,
	Boolean $service_enabled,
)
{

	# Change some defaults in the /etc/snmpcollector/config.toml file.
	file { '/etc/snmpcollector/config.toml' :
		ensure => present,
	} -> 
	file_line { 'instanceID' :
		path => '/etc/snmpcollector/config.toml',
		line => " instanceID = \"${instance_name}\"",
		match => '^ instanceID.*$',
		ensure => 'present',
		#notify => Service["snmpcollector"]
	} ->
	file_line { 'web_port' :
		path => '/etc/snmpcollector/config.toml',
		line => " port = ${web_port}",
		match => '^ port.*$',
		ensure => 'present',
		#notify => Service["snmpcollector"]
	} ->
	file_line { 'web_adminuser' :
		path => '/etc/snmpcollector/config.toml',
		line => " adminuser = \"${admin_username}\"",
		match => '^ adminuser.*$',
		ensure => 'present',
		#notify => Service["snmpcollector"]
	} ->
	file_line { 'web_adminpassword' :
		path => '/etc/snmpcollector/config.toml',
		line => " adminpassword = \"${admin_password}\"",
		match => '^ adminpassword.*$',
		ensure => 'present',
		#notify => Service["snmpcollector"]
	} ->
	file_line { 'web_cookie' :
		path => '/etc/snmpcollector/config.toml',
		line => " cookieid = \"${instance_name}_cookie\"",
		match => '^ cookieid.*$',
		ensure => 'present',
		#notify => Service["snmpcollector"]
	}

	# Setup the client config file to hit the API.
	$snmpcollector_rest_config = @("END")
		url: http://localhost:${web_port}
		username: ${admin_username}
		password: ${admin_password}
		|END

	file { '/etc/puppetlabs/puppet/snmpcollector_conf.yaml' :
		ensure => present,
		content => $snmpcollector_rest_config,
	}


}