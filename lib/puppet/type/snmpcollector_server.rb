Puppet::Type.newtype(:snmpcollector_server) do
	desc 'Snmpcollector Server.'

	ensurable

	newparam(:name, :namevar => true) do
		desc 'Name for the server for uniqueness.'
	end

	def refresh
		provider.refresh
	end


end