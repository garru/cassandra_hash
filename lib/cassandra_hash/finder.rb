module CassandraHash
  # Finders return objects
  # Its API is exactly like accessor except accessors return attributes [Hash]
  class Finder
    attr_accessor :accessor
    
    def initialize(accessor)
      self.accessor = accessor
    end
    
    def get(klass, keys)
      case keys
      when Array
        accessor.get(klass, keys).inject({}) do |values, (key, value)|
          values[key] = klass.new(key, value)
          values
        end
      else
        klass.new(keys, accessor.get(klass, keys))
      end
    end
    
    def set(klass, key, attributes)
      accessor.set(klass, key, attributes)
    end
    
    def clear_session
      
    end
  end
end