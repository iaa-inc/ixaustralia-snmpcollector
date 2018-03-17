Puppet::Type.newtype(:snmpcollector_measurement_group) do
	desc 'Describes an Measurement Group.'

	ensurable

	autorequire(:snmpcollector_measurement) do
		self[:measurements]
	end

	newparam(:name, :namevar => true) do
		desc 'Name for the group.'
	end

	newproperty(:measurements, :array_matching => :all) do
		desc 'Name of the SNMP Field.'
	end

	newproperty(:description) do
		desc 'Description.'
		defaultto 'MANAGED BY PUPPET'
	end
end