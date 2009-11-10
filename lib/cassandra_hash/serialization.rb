module CassandraHash
  class Serialization
    attr_accessor :serializer
    def initialize(serializer)
       self.serializer = serializer
    end
    
    def encode(attributes = {})
      attributes.inject({}) do |hash, (key, value)|
        hash[key] = self.serializer.encode(value)
        hash
      end
    end
    
    def decode(attributes = {})
      attributes.inject({}) do |hash, (key,value)|
        hash[key] = self.serializer.decode(value)
        hash
      end
    end
  end
end