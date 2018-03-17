# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# https://docs.puppet.com/guides/tests_smoke.html
#
class {'snmpcollector' :
    instance_name => 'collector01',
	web_port => 8000,
	admin_username => 'admin',
	admin_password => 'the_best_admin',
	service_enabled => true,
}

snmpcollector::influxserver { 'metrics' :
	host => 'localhost',
	username => 'admin',
	password => 'admin',
	database => 'metrics'
}

snmpcollector::device { 'test5' : 
	ensure => 'present', 
	host => 'test-new-2.testing1234.com',
	output_database => 'metrics',
	snmp_community => 'p4snmpcomm',
	extra_tags => ['ix=per','pop=per1', 'test=hello'],
}

snmpcollector::metric { 'ifOctetsIn' :
	ensure => 'present',
	field_name => 'ifOctetsIn',
	base_oid => '.1.3.5.5.5.2.1',
	datasource_type => 'Counter64',
}

snmpcollector::measurement { 'interfaces' :
	ensure => 'present',
	get_mode => 'indexed',
	index_oid => '.1.5.6.8.2.5',
	index_tag => 'ifName',
	fields => [
	{
		name => 'ifOctetsIn',
		report => 1,
	}],
}

snmpcollector::measurement_group { 'interfaces_group' :
	ensure => 'present',
	measurements => ['interfaces']
}
