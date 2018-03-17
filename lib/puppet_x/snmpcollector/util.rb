module Snmpcollector
	class Util
	    def self.munge_boolean(value)
	      return true if [true, "true", :true].include? value
	      return false if [false, "false", :false].include? value
	    end

	    def self.sym_to_bool(sym)
      		nil == sym ? nil : :true == sym
    	end
	end
end