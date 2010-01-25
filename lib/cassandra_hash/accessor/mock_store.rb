module CassandraHash
  module Accessor
    # Persistence Stores need to support 2 methods.
    class MockStore < Abstract
      attr_accessor :serializer
      def initialize
        @classes = Hash.new{|h,k| h[k] = {}}
      end

      def get(klass, keys)
        case keys
        when Array
          keys.inject({}) do |values, key|
            values[key] = expand(@classes[klass.name][key] || {})
            values
          end
        else
          expand(@classes[klass.name][keys] || {})
        end
      end

      def set(klass, key, attributes)
        @classes[klass.name][key] = rollup(attributes)
      end
      
      def delete(klass, key)
        @classes[klass.name].delete(key)
      end
      
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
    end
  end
end