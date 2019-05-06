Puppet::Type.newtype(:snmpcollector_metric) do
	desc 'Describes an SNMP Metric.'

	ensurable

	newparam(:name, :namevar => true) do
		desc 'Name for the Metric.'
	end

	newproperty(:field_name) do
		desc 'Name of the SNMP Field.'
		defaultto ''
	end

	newproperty(:description) do
		desc 'Description for the metric.'
		defaultto 'MANAGED BY PUPPET.'
	end

	newproperty(:base_oid) do
		desc 'Base OID for the metric.'
		defaultto ''
	end

	newproperty(:datasource_type) do
		desc 'Type of the metric'
		defaultto ''
	end

	newproperty(:get_rate) do
		desc 'Automatically convert to a rate.'
		defaultto false
	end

	newproperty(:scale) do
		desc 'Scale the metric automatically.'
		defaultto 0
	end

	newproperty(:shift) do
		desc 'Shift the metric automatically.'
		defaultto 0
	end

	newproperty(:is_tag) do
		desc 'Use this metric as a tag rather than a value.'
		defaultto false
	end

	newproperty(:extra_data) do
		desc 'Additional Data.'
		defaultto ''
	end

	newproperty(:conversion) do
		desc 'Conversion value'
		defaultto 0
	end
end

