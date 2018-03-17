require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'client.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'util.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'mapping.rb'))

Puppet::Type.type(:snmpcollector_measurement).provide(:ruby) do

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
  	# for all measurementss defined in the collector.
	def self.instances
		# Create a new API client and get all measurements.
		client = Snmpcollector::Client.new
		
		measurements = client.get('measurement', nil)

		if ! measurements.nil?
			# Munge the measurements into hash with the nice puppet field names.
		  	measurements.collect do |measurement| 

		  		measurement_properties = {}

		  		Snmpcollector::Mapping.measurement.each do | key, value |

            # Treat the fields as a sub-type (nested)
            if key == 'fields'
              measurement_properties[key.to_sym] = []
              
              # loop through the fields returned and do a mapping on them.
              measurement[value].each do | field |
                f = {}
                # referencing the sub-mapping.
                Snmpcollector::Mapping.measurement_fields.each do | k, v |
                  f[k] = field[v]
                end

                measurement_properties[key.to_sym] << f #array append
              end
            else
              measurement_properties[key.to_sym] = measurement[value]
            end
		  		end

		  		measurement_properties[:ensure] = :present

		  		new(measurement_properties)

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
    	measurements = instances

    	if ! measurements.nil?
    		resources.keys.each do |name|
		      	if provider = measurements.find { |measurement| measurement.name == name }
		        	resources[name].provider = provider
		      	end
    		end
    	end
  	end

  	# Convert Puppet Resource to the Snmpcollector API.
  	def resource_to_api
  		api_resource = {}

  		Snmpcollector::Mapping.measurement.invert.each do |key, value|
        if value == 'fields'
          
          api_resource[key] = []

          resource[value].each do | field |
            f = {}

            Snmpcollector::Mapping.measurement_fields.invert.each do | k, v |
              f[k] = field[v]
            end

            api_resource[key] << f

          end
        else
          api_resource[key] = resource[value]
        end
  		end

      # Special Sauce because duplicate fields make the baby jesus cry.
      api_resource[:name] = resource[:name]

      Puppet::debug("Resource to API: #{api_resource}")
  		api_resource
  	end

  	# Perform a POST to the measurements type endpoint to create a new measurement.
  	def create
  		Puppet::debug("POST to create #{resource['name']}")
  		
  		if @api_client.nil?
  			@api_client = Snmpcollector::Client.new
  		end
  		
  		result = @api_client.post('measurement', resource_to_api)
  		
  		@flush_required = false
  	end

  	# Perform a DELETE to the measurements type endpoint to destroy a measurement.
  	def destroy
  		Puppet::debug("DELETE to destroy #{resource['name']}")

  		if @api_client.nil?
  			@api_client = Snmpcollector::Client.new
  		end
  		
  		result = @api_client.delete('measurement', resource['name'])
  		
  		@flush_required = false
  	end

  	# On any change, cause a PUT to the measurements type endpoint to 
  	# fully update the measurement as the API doesn't support PATCH.
  	def flush
  		if @flush_required
  			if @api_client.nil?
  				@api_client = Snmpcollector::Client.new
  			end
  			
  			Puppet::debug("PUT to update #{resource['name']}")
  			
  			result = @api_client.put('measurement', resource['name'], resource_to_api)
  		end
  	end
end