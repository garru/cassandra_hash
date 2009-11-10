module CassandraHash
  class Base
    class << self
      # make this a class_attr_accessor
      # attr_accessor :connection, :persistence_store, :serializer
      attr_accessor :repo_name
      
      def [](key)
        attributes = persistence.get(key.to_s)
        new(key, attributes)
      end

      def []=(key, attributes)
        persistence.set(key.to_s, attributes)
      end
      
      def persistence
        @persistance ||= begin 
          Persistence.new(column_family_name, @@persistence_store, serialization)
        end
      end
      
      def serialization
        Serialization.new(@@serializer)
      end
      
      def persistence_store=(persistence_store)
        @@persistence_store = persistence_store
      end
      
      def serializer=(serializer)
        @@serializer = serializer
      end
      
      def column_family(column_family)
        @column_family = column_family 
      end
      
      def column_family_name
        @column_family || name
      end
    end

    attr_accessor :key, :attributes

    def initialize(key, attributes = {})
      @key = key
      self.attributes = attributes.dup
    end
    
    def []=(name, value)
      self.attributes[name] = value
    end

    def [](name)
      self.attributes[name]
    end
    
    def save
      self.class[@key] = self.attributes
    end
  end
end