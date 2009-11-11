module CassandraHash
  class IdentityMap
    attr_accessor :decorated
    
    def initialize(decorated)
      self.decorated = decorated
    end

    def get(klass, keys)
      case keys
      when Array
        keys.inject({}) do |values, key|
          values[key] = fetch(klass, key)
          values
        end
      else
        fetch(klass, keys)
      end
    end

    def set(klass, key, attributes)
      decorated.set(klass, key, attributes)
    end

    def clear_session
      Thread.current[:identity_map] ||= {}
      Thread.current[:identity_map].clear
    end
    
private
    def fetch(klass, key)
      name_hash = Thread.current[:identity_map][klass.name] ||= {}
      if name_hash.nil? || name_hash[key].nil?
        name_hash[key] = decorated.get(klass,key)
      else
        name_hash[key]
      end
    end
  end
end