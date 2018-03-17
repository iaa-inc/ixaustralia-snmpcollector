require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'client.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'util.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'mapping.rb'))

Puppet::Type.type(:snmpcollector_device).provide(:ruby) do

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
  	# for all snmpdevices defined in the collector.
	def self.instances
		# Create a new API client and get all devices.
		client = Snmpcollector::Client.new
		
		devices = client.get('snmpdevice', nil)

		if ! devices.nil?
			# Munge the devices into hash with the nice puppet field names.
		  	devices.collect do |device| 

		  		device_properties = {}

		  		Snmpcollector::Mapping.snmpdevice.each do | key, value |
		  			device_properties[key.to_sym] = device[value]
		  		end

		  		device_properties[:ensure] = :present

		  		new(device_properties)

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
    	devices = instances

    	if ! devices.nil?
    		resources.keys.each do |name|
		      	if provider = devices.find { |device| device.name == name }
		        	resources[name].provider = provider
		      	end
    		end
    	end
  	end

  	# Convert Puppet Resource to the Snmpcollector API.
  	def resource_to_api
  		api_resource = {}

  		Snmpcollector::Mapping.snmpdevice.invert.each do |key, value|
			api_resource[key] = resource[value]
  		end

  		api_resource
  	end

  	# Perform a POST to the snmpdevice type endpoint to create a new device.
  	def create
  		Puppet::debug("POST to create #{resource['name']}")
  		
  		if @api_client.nil?
  			@api_client = Snmpcollector::Client.new
  		end
  		
  		result = @api_client.post('snmpdevice', resource_to_api)
  		
  		@flush_required = false
  	end

  	# Perform a DELETE to the snmpdevice type endpoint to destroy a device.
  	def destroy
  		Puppet::debug("DELETE to destroy #{resource['name']}")

  		if @api_client.nil?
  			@api_client = Snmpcollector::Client.new
  		end
  		
  		result = @api_client.delete('snmpdevice', resource['name'])
  		
  		@flush_required = false
  	end

  	# On any change, cause a PUT to the snmpdevice type endpoint to 
  	# fully update the device as the API doesn't support PATCH.
  	def flush
  		if @flush_required
  			if @api_client.nil?
  				@api_client = Snmpcollector::Client.new
  			end
  			
  			Puppet::debug("PUT to update #{resource['name']}")
  			
  			result = @api_client.put('snmpdevice', resource['name'], resource_to_api)
  		end
  	end
end
