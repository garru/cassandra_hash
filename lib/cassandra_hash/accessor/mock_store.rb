module CassandraHash
  module Accessor
    # Persistence Stores need to support 2 methods.
    class MockStore < Abstract
      def initialize
        @classes = Hash.new{|h,k| h[k] = {}}
      end

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

      def set(klass, key, attributes)
        @classes[klass.name][key] = attributes
      end
    end
  end
end