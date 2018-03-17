Puppet::Type.newtype(:snmpcollector_device) do
	desc 'Manage devices configured under snmpcollector.'

	ensurable

	autorequire(:snmpcollector_influxserver) do
		self[:output_database]
	end

	newparam(:name, :namevar => true) do
		desc 'The name and identifier of the device.'
	end	

	newproperty(:host) do
		desc 'The hostname of the device'
	end

	newproperty(:port) do
		desc 'SNMP Port to talk to the device on.'
	end

	newproperty(:retries) do
		desc 'SNMP Retry attempts.'
	end

	newproperty(:timeout) do
		desc 'SNMP Timeout.'
	end

	newproperty(:repeat) do
		desc 'No idea.'
	end

	newproperty(:active) do
		desc 'Device active state.'
	end

	newproperty(:snmp_version) do
		desc 'SNNMP Version'
	end

	newproperty(:snmp_community) do
		desc 'SNMP Community string'
	end

	newproperty(:snmpv3_sec_level) do
		desc 'SNMPv3 Security Level'
	end

	newproperty(:snmpv3_auth_user) do
		desc 'SNMPv3 Security Level'
	end

	newproperty(:snmpv3_auth_pass) do
		desc 'SNMPv3 Security Level'
	end

	newproperty(:snmpv3_auth_prot) do
		desc 'SNMPv3 Security Level'
	end

	newproperty(:snmpv3_priv_pass) do
		desc 'SNMPv3 Security Level'
	end

	newproperty(:snmpv3_priv_prot) do
		desc 'SNMPv3 Security Level'
	end

	newproperty(:disable_bulk) do
		desc 'Disable bulk queries'
	end

	newproperty(:max_repetitions) do
		desc 'SNMP Bulk batch size'
	end

	newproperty(:frequency) do
		desc 'SNMP Interval'
	end

	newproperty(:update_frequency) do
		desc 'Filter frequency update.'
	end

	newproperty(:concurrent_gather) do
		desc 'No idea.'
	end

	newproperty(:output_database) do
		desc 'Output Influx DB'
	end

	newproperty(:log_level) do
		desc 'Log level'
	end

	newproperty(:log_file) do
		desc 'Log File'
	end

	newproperty(:snmp_debug) do
		desc 'Snmp Debug switch'
	end

	newproperty(:device_tag_name) do
		desc 'Tag Name'
	end

	newproperty(:device_tag_value) do
		desc 'Tag value'
	end

	newproperty(:extra_tags, :array_matching => :all) do
		desc 'Influx Tags to include'
	end

	newproperty(:description) do
		desc 'Description'
	end

	newproperty(:measurement_groups, :array_matching => :all) do
		desc 'Meansurement Groups'
	end

	newproperty(:measurement_filters, :array_matching => :all) do
		desc 'Measurement Filters'
	end

end
