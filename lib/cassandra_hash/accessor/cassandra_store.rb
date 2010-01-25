require 'cassandra'
class Cassandra
  def closed?
    false
  end

  def close
    raw_client.disconnect!
    @client = nil
  end
end

module CassandraHash
  module Accessor
    class CassandraStore < Abstract
      attr_accessor :serializer
      def initialize(*args)
        @connection_pool = Pandemic::ConnectionPool.new
        @connection_pool.create_connection{ Cassandra.new(*args) }
        @connection_pool.destroy_connection{|c| c.client.disconnect!}
      end
      
      
      # def connection_pool
      #   @connection_pool ||= begin
      #     processor = ConnectionPool.new
      #     processor.create_connection { Processor.new(@handler) }
      #     processor
      #   end
      # end
      # Get takes the class name of an object and its key; 
      #      and returns the attributes
  
      # @param [String]
      # @return [Hash]
      def get(klass, keys)
        name = klass.column_family_name
        case keys
        when Array
          keys = keys.map{|key|keys.to_s}
          values = @connection_pool.with_connection{|c| c.multi_get(name, keys)}
          values.inject({}) do |hash, (key, encoded_attributes)|
            hash[key.to_sym] = expand(encoded_attributes)
            hash
          end
        else
          encoded_attributes = @connection_pool.with_connection{|c| c.get(name, keys.to_s)}
          expand(encoded_attributes)
        end        
      end
  
      # Set saves takes the class name of an object and its key; 
      #      and returns the attributes
  
      # @param [String], [String], [Hash]
      # @return [Hash]
      def set(klass, key, attributes)
        name = klass.column_family_name
        @connection_pool.with_connection{|c| c.insert(name, key.to_s, rollup(attributes))}
      end
      
      def delete(klass, key)
        @connection_pool.with_connection{|c| c.remove(klass.connection_family_name, key.to_s)}
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