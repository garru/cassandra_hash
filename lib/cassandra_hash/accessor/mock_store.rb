module CassandraHash
  module Accessor
    # Persistence Stores need to support 2 methods.
    class MockStore < Abstract
      def initialize
        @classes = Hash.new{|h,k| h[k] = {}}
      end
      # Get takes the class name of an object and its key; 
      #      and returns the attributes
    
      # @param [String]
      # @return [Hash]
      def get(klass, keys)
        case keys
        when Array
          keys.inject({}) do |values, key|
            values[key] = @classes[klass.name][key] || {}
            values
          end
        else
          @classes[klass.name][keys] || {}
        end
      end
    
      # Set saves takes the class name of an object and its key; 
      #      and returns the attributes
    
      # @param [String], [String], [EncodedHash]
      # @return [EncodedHash]
      def set(klass, key, attributes)
        @classes[klass.name][key] = attributes
      end
    end
  end
end