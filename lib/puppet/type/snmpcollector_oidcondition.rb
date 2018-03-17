Puppet::Type.newtype(:snmpcollector_oidcondition) do
	desc 'Describes an SNMP OID Condition.'

	ensurable

	newparam(:name, :namevar => true) do
		desc 'Name for the OID condition.'
	end

	newproperty(:is_multiple) do
		desc 'Does this condition aggregate other conditions'
		defaultto false
	end

	newproperty(:condition) do
		desc 'OID Condition statement'
		defaultto ''
	end

	newproperty(:condition_type) do
		desc 'Type of the condition'
		defaultto ''
	end

	newproperty(:condition_value) do
		desc 'Value the condition should match'
		defaultto ''
	end

	newproperty(:description) do
		desc 'Description of the condition'
		defaultto 'MANAGED BY PUPPET'
	end
end