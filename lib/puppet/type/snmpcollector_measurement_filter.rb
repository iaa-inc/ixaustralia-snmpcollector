Puppet::Type.newtype(:snmpcollector_measurement_filter) do
	desc 'Describes an Measurement Filter.'

	ensurable

	autorequire(:snmpcollector_measurement) do
		self[:measurement]
	end

	newparam(:name, :namevar => true) do
		desc 'Name for the filter.'
	end

	newparam(:filter_name) do
		desc 'Name for the filter... because why?'
	end

	newproperty(:measurement) do
		desc 'Name of the measurement to filter.'
		defaultto ''
	end

	newproperty(:filter_type) do
		desc 'Type of the measurement to filter.'
		defaultto ''
	end

	newproperty(:enable_alias) do
		desc 'Enable filter alias.'
	end

	newproperty(:description) do
		desc 'Description.'
		defaultto 'MANAGED BY PUPPET'
	end
end