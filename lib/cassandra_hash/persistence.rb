module CassandraHash
  class Persistence
    attr_accessor :name, :persistance_store, :serializer
    
    def initialize(name, persistance_store, serializer)
      self.name = name
      self.persistance_store = persistance_store
      self.serializer = serializer
    end
    
    def get(key)
      encoded_attributes = persistance_store.get(name, key)
      serializer.decode(encoded_attributes)
    end
    
    def set(key, attributes)
      encoded_attributes = serializer.encode(attributes)
      persistance_store.set(name, key, encoded_attributes)
    end
  end
end