module CassandraHash
  # Persistence Stores need to support 2 methods.
  module Accessor
    class Abstract
      # Get takes the class name of an object and its key; 
      #      and returns the attributes
    
      # @param [String], [Array] or [String]
      # @return [Hash]
      def get(klass, keys)
      
      end
    
      # Set saves takes the class name of an object and its key; 
      #      and returns the attributes
    
      # @param [String], [String], [EncodedHash]
      # @return [EncodedHash]
      def set(klass, key, attributes)
      
      end
    end
  end
end