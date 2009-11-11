module CassandraHash
  class Base
    class << self

      def [](key)
        @@finder.get(self, key)
      end

      def []=(key, attributes)
        @@finder.set(self, key, attributes)
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