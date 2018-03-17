Puppet::Type.newtype(:snmpcollector_influxserver) do
	desc "Managed InfluxDB Servers configured in SNMPCollector"

	ensurable

	newparam(:name, :namevar => true) do
		desc 'The name and identifier of the influxdb server.'
	end	

	newproperty(:host) do
		desc 'Hostname of the influxdb server.'
	end

	newproperty(:port) do
		desc 'Port to talk to the influxdb HTTP API on.'
	end

	newproperty(:database) do
		desc 'Database name to write to.'
	end

	newproperty(:username) do 
		desc 'Username to use to connect to the database'
	end

	newproperty(:password) do
		desc 'Password to use to connect to the database'
	end

	newproperty(:retention) do
		desc 'Retention policy to use on the database'
	end

	newproperty(:precision) do
		desc 'Time level precision I assume.'
	end

	newproperty(:timeout) do
		desc 'Connection timeout to the database'
	end

	newproperty(:user_agent) do
		desc 'Custom user agent to connect to DB with.'
	end

	newproperty(:description) do
		desc 'Description'
	end
end