require 'cassandra'
module CassandraHash
  module Accessor
    class CassandraStore < Abstract
      attr_accessor :serializer
      def initialize(*args)
        self.serializer = args[:serializer]
        @connection = Cassandra.new(*args)
      end
      # Get takes the class name of an object and its key; 
      #      and returns the attributes
  
      # @param [String]
      # @return [Hash]
      def get(klass, keys)
        name = klass.column_family_name
        case keys
        when Array
          values = @connection.multi_get(name, keys)
          values.inject({}) do |hash, (key, encoded_attributes)|
            hash[key] = serializer.decode(encoded_attributes)
            hash
          end
        else
          encoded_attributes = @connection.get(name, keys)
          serializer.decode(encoded_attributes)
        end        
      end
  
      # Set saves takes the class name of an object and its key; 
      #      and returns the attributes
  
      # @param [String], [String], [EncodedHash]
      # @return [EncodedHash]
      def set(klass, key, attributes)
        name = klass.column_family_name
        @connection.insert(name, key, attributes)
      end
    end
  end
end