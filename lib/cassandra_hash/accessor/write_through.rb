module CassandraHash
  module Accessor
    class WriteThrough < Abstract
      attr_accessor :decorated, :repository, :namespace
    
      def initialize(decorated, options = {})
        self.decorated = decorated
        self.repository = options[:repository]
        self.namespace = options[:namespace] || ""
      end
    
      def get(klass, keys)
        case keys
        when Array
          cache_keys = keys.map{|key| cache_key(klass, key)}
          hits = repository.get_multi(cache_keys)
          if (missed_keys = cache_keys - hits.keys)
            missed_values = decorated.get(klass, keys)
            hits.merge!(missed_values)
          end
          hits
        else
          attributes = nil
          begin
            attributes = repository.get(cache_key(klass, keys)) 
          rescue Memcached::NotFound 
            attributes = decorated.get(klass, keys)
            repository.set(cache_key(klass,keys), attributes)
          end
          attributes
        end
      end
  
      def set(klass, key, attributes)
        decorated.set(klass, key, attributes)
        repository.set(cache_key(klass, key), attributes)
      end

  private
    
      def cache_key(klass, key)
        [namespace, klass.column_family_name, key].join("/")
      end
    end
  end
end