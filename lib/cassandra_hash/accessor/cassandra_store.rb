require 'cassandra'
module CassandraHash
  module Accessor
    class CassandraStore < Abstract
      attr_accessor :serializer
      def initialize(*args)
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
          keys = keys.map{|key|keys.to_s}
          values = @connection.multi_get(name, keys)
          values.inject({}) do |hash, (key, encoded_attributes)|
            hash[key] = expand(encoded_attributes)
            hash
          end
        else
          encoded_attributes = @connection.get(name, keys.to_s)
          expand(encoded_attributes)
        end        
      end
  
      # Set saves takes the class name of an object and its key; 
      #      and returns the attributes
  
      # @param [String], [String], [Hash]
      # @return [Hash]
      def set(klass, key, attributes)
        name = klass.column_family_name
        @connection.insert(name, key.to_s, rollup(attributes))
      end

private

      def expand(encoded_attributes)
        encoded_attributes.inject({}) do |hash, (key, value)|
          hash[key.to_sym] = serializer.decode(value)
          hash
        end
      end
      
      def rollup(attributes)
        attributes.inject({}) do |hash, (key, value)|
          hash[key.to_s] = serializer.encode(value)
          hash
        end
      end
      
      def serializer
        @serializer ||= JSONSerializer.new
      end
    end
  end
end