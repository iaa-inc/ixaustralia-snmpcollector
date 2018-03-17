# require 'rest-client'
# require 'json'
# require 'puppet'
# require 'yaml'


module Snmpcollector
	class Client
		def initialize
            begin
    			@config_path ||= File.expand_path(File.join('/etc/puppetlabs/puppet', '/snmpcollector_conf.yaml'))

    			@config ||= YAML.load_file(@config_path)

    			url = @config['url'] + "/login"

      			auth_resp = RestClient.post url, {username: @config["username"], password: @config["password"]}

    	      	@cookie_jar = auth_resp.cookie_jar

            rescue RestClient::ExceptionWithResponse => e
                raise Puppet::Error, "Exception: #{e.response}"
            end
		end

		def get_path(type, id)
			if id.nil?
    			path = "#{@config['url']}/api/cfg/#{type}"
    		else
    			path = "#{@config['url']}/api/cfg/#{type}/#{id}"
    		end
		end


    	def get(type, id)
            begin
			    resp = RestClient.get get_path(type, id), cookies: @cookie_jar

                Puppet::debug("JSON Body: #{resp.body}")

                if resp.body == 'null'
                    return nil
                end
                
                JSON.parse resp.body

            rescue RestClient::ExceptionWithResponse => e
                raise Puppet::Error, "Exception: #{e.response}"
            end
    	end

    	def post(type, payload)
            Puppet::debug("POST to create: #{payload}")
    		begin
        		resp = RestClient.post get_path(type, nil), 
    					   payload.to_json, 
    					   cookies: @cookie_jar, 
    					   content_type: :json, 
    					   accept: :json
                JSON.parse(resp.body)

            rescue RestClient::ExceptionWithResponse => e
                raise Puppet::Error, "Exception: #{e.response}"
            end
    	end

    	def put(type, id, payload)
            Puppet::debug("PUT to update: #{payload}")
    		if id.nil?
    			# throw error
    		end

            begin
        		resp = RestClient.put get_path(type, id), 
        							   payload.to_json, 
        							   cookies: @cookie_jar, 
        							   content_type: :json, 
        							   accept: :json

            rescue RestClient::ExceptionWithResponse => e
                raise Puppet::Error, "Exception: #{e.response}"
            end

    		JSON.parse(resp.body)

    	end

    	def delete(type, id)

    		if id.nil?
    			# throw error
    		end
            
            begin
                resp = RestClient.delete get_path(type, id), cookies: @cookie_jar
            rescue RestClient::ExceptionWithResponse => e
                raise Puppet::Error, "Exception: #{e.response}"
            end
    	end

        def reload()
            begin
                url = @config['url'] + "/api/rt/agent/reload/"
                resp = RestClient.get url, cookies: @cookie_jar
            rescue RestClient::ExceptionWithResponse => e
                raise Puppet::Error, "Exception: #{e.response}"
            end
        end
 
	end

end







