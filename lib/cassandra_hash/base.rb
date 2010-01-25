require 'cassandra_hash/associations'

module CassandraHash
  class Base
    extend Associations    
    class << self

      def [](key)
        @@finder.get(self, key)
      end

      def []=(key, attributes)
        @@finder.set(self, key, attributes)
      end
      
      def delete(key)
        @@finder.delete(self, key)
      end
      
      def multi_get(keys)
        @@finder.get(self, keys)
      end

      # make these a class_attr_accessor      
      def finder=(finder)
        @@finder = finder
      end
      
      def column_family(column_family)
        @column_family = column_family 
      end
      
      def column_family_name
        @column_family || name
      end
      
      def clear_session
        @@finder.clear_session
      end
    end

    attr_accessor :key, :attributes

    def initialize(key, attributes = {})
      @key = key
      self.attributes = attributes.nil? ? attributes : attributes.dup
      @associations = {}
      @dirty_attributes = {}
    end
    
    def []=(name, value)
      @dirty_attributes[name] = self.attributes[name] = value
    end

    def [](name)
      self.attributes[name]
    end
    
    def save
      self.class[@key] = self.attributes
      @associations.each_pair do |association_name, association_value|
        association_value.save
      end
    end
  end
end