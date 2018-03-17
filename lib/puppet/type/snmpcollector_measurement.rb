Puppet::Type.newtype(:snmpcollector_measurement) do
	desc 'Describes a Measurement.'

	ensurable

	autorequire(:snmpcollector_metric) do
		self[:fields]
	end

	newparam(:name, :namevar => true) do
		desc 'Name for the Measurement.'
	end

	newproperty(:get_mode) do
		desc 'Get mode.'
	end

	newproperty(:index_oid) do
		desc 'Index OID'
	end

	newproperty(:tag_oid) do
		desc 'Tag OID'
	end

	newproperty(:index_tag) do
		desc 'Index tag name.'
	end

	newproperty(:index_tag_format) do
		desc 'Index tag format.'
	end

	newproperty(:index_as_value) do
		desc 'Index as value'
	end

	newproperty(:fields, :array_matching => :all) do
		desc 'Metrics to include in the measurement.'
	end

	newproperty(:description) do
		desc 'Description.'
	end
end