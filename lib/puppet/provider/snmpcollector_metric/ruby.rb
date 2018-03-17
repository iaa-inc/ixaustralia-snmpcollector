require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'client.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'util.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'mapping.rb'))

Puppet::Type.type(:snmpcollector_metric).provide(:ruby) do

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
  	# for all metricss defined in the collector.
	def self.instances
		# Create a new API client and get all metrics.
		client = Snmpcollector::Client.new
		
		metrics = client.get('metric', nil)

		if ! metrics.nil?
			# Munge the metrics into hash with the nice puppet field names.
		  	metrics.collect do |metric| 

		  		metric_properties = {}

		  		Snmpcollector::Mapping.metric.each do | key, value |
		  			metric_properties[key.to_sym] = metric[value]
		  		end

		  		metric_properties[:ensure] = :present

		  		new(metric_properties)

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
    	metrics = instances

    	if ! metrics.nil?
    		resources.keys.each do |name|
		      	if provider = metrics.find { |metric| metric.name == name }
		        	resources[name].provider = provider
		      	end
    		end
    	end
  	end

  	# Convert Puppet Resource to the Snmpcollector API.
  	def resource_to_api
  		api_resource = {}

  		Snmpcollector::Mapping.metric.invert.each do |key, value|
			   api_resource[key] = resource[value]
  		end

      Puppet::debug("Resource to API: #{api_resource}")
  		api_resource
  	end

  	# Perform a POST to the metrics type endpoint to create a new metric.
  	def create
  		Puppet::debug("POST to create #{resource['name']}")
  		
  		if @api_client.nil?
  			@api_client = Snmpcollector::Client.new
  		end
  		
  		result = @api_client.post('metric', resource_to_api)
  		
  		@flush_required = false
  	end

  	# Perform a DELETE to the metrics type endpoint to destroy a metric.
  	def destroy
  		Puppet::debug("DELETE to destroy #{resource['name']}")

  		if @api_client.nil?
  			@api_client = Snmpcollector::Client.new
  		end
  		
  		result = @api_client.delete('metric', resource['name'])
  		
  		@flush_required = false
  	end

  	# On any change, cause a PUT to the metrics type endpoint to 
  	# fully update the metric as the API doesn't support PATCH.
  	def flush
  		if @flush_required
  			if @api_client.nil?
  				@api_client = Snmpcollector::Client.new
  			end
  			
  			Puppet::debug("PUT to update #{resource['name']}")
  			
  			result = @api_client.put('metric', resource['name'], resource_to_api)
  		end
  	end
end