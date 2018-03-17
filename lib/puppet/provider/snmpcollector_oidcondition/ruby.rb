require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'client.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'util.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'mapping.rb'))

Puppet::Type.type(:snmpcollector_oidcondition).provide(:ruby) do

  confine :feature => [:restclient, :json, :yaml]

	# Generate setter and getter methods
	# that pull from @property_hash which is populated by instances.
	mk_resource_methods

	def initialize(value={})
		super(value)
		
		@api_client = nil
		
		@flush_required = true
	end

  	# Returns an array of instances of this provider 
  	# for all oidconditionss defined in the collector.
	def self.instances
		# Create a new API client and get all oidconditions.
		client = Snmpcollector::Client.new
		
		oidconditions = client.get('oidcondition', nil)

		if ! oidconditions.nil?
			# Munge the oidconditions into hash with the nice puppet field names.
		  	oidconditions.collect do |oidcondition| 

		  		oidcondition_properties = {}

		  		Snmpcollector::Mapping.oidcondition.each do | key, value |
		  			oidcondition_properties[key.to_sym] = oidcondition[value]
		  		end

		  		oidcondition_properties[:ensure] = :present

		  		new(oidcondition_properties)

		  	end
		end
	end

	# Check for existence
	def exists?
		@property_hash[:ensure] == :present
	end

	# Prefetch to make stuff easier.
	# just calls instances and assigns to it's provider.
	def self.prefetch(resources)
    	oidconditions = instances

    	if ! oidconditions.nil?
    		resources.keys.each do |name|
		      	if provider = oidconditions.find { |oidcondition| oidcondition.name == name }
		        	resources[name].provider = provider
		      	end
    		end
    	end
  	end

  	# Convert Puppet Resource to the Snmpcollector API.
  	def resource_to_api
  		api_resource = {}

  		Snmpcollector::Mapping.oidcondition.invert.each do |key, value|
			   api_resource[key] = resource[value]
  		end

      Puppet::debug("Resource to API: #{api_resource}")
  		api_resource
  	end

  	# Perform a POST to the oidconditions type endpoint to create a new oidcondition.
  	def create
  		Puppet::debug("POST to create #{resource['name']}")
  		
  		if @api_client.nil?
  			@api_client = Snmpcollector::Client.new
  		end
  		
  		result = @api_client.post('oidcondition', resource_to_api)
  		
  		@flush_required = false
  	end

  	# Perform a DELETE to the oidconditions type endpoint to destroy a oidcondition.
  	def destroy
  		Puppet::debug("DELETE to destroy #{resource['name']}")

  		if @api_client.nil?
  			@api_client = Snmpcollector::Client.new
  		end
  		
  		result = @api_client.delete('oidcondition', resource['name'])
  		
  		@flush_required = false
  	end

  	# On any change, cause a PUT to the oidconditions type endpoint to 
  	# fully update the oidcondition as the API doesn't support PATCH.
  	def flush
  		if @flush_required
  			if @api_client.nil?
  				@api_client = Snmpcollector::Client.new
  			end
  			
  			Puppet::debug("PUT to update #{resource['name']}")
  			
  			result = @api_client.put('oidcondition', resource['name'], resource_to_api)
  		end
  	end
end
