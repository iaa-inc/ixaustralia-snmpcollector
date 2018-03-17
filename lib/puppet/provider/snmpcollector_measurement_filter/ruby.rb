require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'client.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'util.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'mapping.rb'))

Puppet::Type.type(:snmpcollector_measurement_filter).provide(:ruby) do

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
    # for all measfilterss defined in the collector.
  def self.instances
    # Create a new API client and get all measfilters.
    client = Snmpcollector::Client.new
        
    measfilters = client.get('measfilters', nil)

    if ! measfilters.nil?
      # Munge the measfilters into hash with the nice puppet field names.
        measfilters.collect do |measfilters| 

          measfilters_properties = {}

          Snmpcollector::Mapping.measurement_filter.each do | key, value |
            measfilters_properties[key.to_sym] = measfilters[value]
          end

          measfilters_properties[:ensure] = :present

          new(measfilters_properties)

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
      measfilters = instances

      if ! measfilters.nil?
        resources.keys.each do |name|
            if provider = measfilters.find { |measfilters| measfilters.name == name }
              resources[name].provider = provider
            end
        end
      end
    end

    # Convert Puppet Resource to the Snmpcollector API.
    def resource_to_api
      api_resource = {}

      Snmpcollector::Mapping.measurement_filter.invert.each do |key, value|
         api_resource[key] = resource[value]
      end

      api_resource
    end

    # Perform a POST to the measfilters type endpoint to create a new measfilters.
    def create
      Puppet::debug("POST to create #{resource['name']}")
      
      if @api_client.nil?
        @api_client = Snmpcollector::Client.new
      end
      
      result = @api_client.post('measfilters', resource_to_api)
      
      @flush_required = false
    end

    # Perform a DELETE to the measfilters type endpoint to destroy a measfilters.
    def destroy
      Puppet::debug("DELETE to destroy #{resource['name']}")

      if @api_client.nil?
        @api_client = Snmpcollector::Client.new
      end
      
      result = @api_client.delete('measfilters', resource['name'])
      
      @flush_required = false
    end

    # On any change, cause a PUT to the measfilters type endpoint to 
    # fully update the measfilters as the API doesn't support PATCH.
    def flush
      if @flush_required
        if @api_client.nil?
          @api_client = Snmpcollector::Client.new
        end
        
        Puppet::debug("PUT to update #{resource['name']}")
        
        result = @api_client.put('measfilters', resource['name'], resource_to_api)
      end
    end
end