require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'client.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'util.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'snmpcollector', 'mapping.rb'))

Puppet::Type.type(:snmpcollector_measurement_group).provide(:ruby) do

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
    # for all measgroupss defined in the collector.
  def self.instances
    # Create a new API client and get all measgroups.
    client = Snmpcollector::Client.new
        
    measgroups = client.get('measgroup', nil)

    if ! measgroups.nil?
      # Munge the measgroups into hash with the nice puppet field names.
        measgroups.collect do |measgroup| 

          measgroup_properties = {}

          Snmpcollector::Mapping.measurement_group.each do | key, value |
            measgroup_properties[key.to_sym] = measgroup[value]
          end

          measgroup_properties[:ensure] = :present

          new(measgroup_properties)

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
      measgroups = instances

      if ! measgroups.nil?
        resources.keys.each do |name|
            if provider = measgroups.find { |measgroup| measgroup.name == name }
              resources[name].provider = provider
            end
        end
      end
    end

    # Convert Puppet Resource to the Snmpcollector API.
    def resource_to_api
      api_resource = {}

      Snmpcollector::Mapping.measurement_group.invert.each do |key, value|
         api_resource[key] = resource[value]
      end

      api_resource
    end

    # Perform a POST to the measgroups type endpoint to create a new measgroup.
    def create
      Puppet::debug("POST to create #{resource['name']}")
      
      if @api_client.nil?
        @api_client = Snmpcollector::Client.new
      end
      
      result = @api_client.post('measgroup', resource_to_api)
      
      @flush_required = false
    end

    # Perform a DELETE to the measgroups type endpoint to destroy a measgroup.
    def destroy
      Puppet::debug("DELETE to destroy #{resource['name']}")

      if @api_client.nil?
        @api_client = Snmpcollector::Client.new
      end
      
      result = @api_client.delete('measgroup', resource['name'])
      
      @flush_required = false
    end

    # On any change, cause a PUT to the measgroups type endpoint to 
    # fully update the measgroup as the API doesn't support PATCH.
    def flush
      if @flush_required
        if @api_client.nil?
          @api_client = Snmpcollector::Client.new
        end
        
        Puppet::debug("PUT to update #{resource['name']}")
        
        result = @api_client.put('measgroup', resource['name'], resource_to_api)
      end
    end
end
