module CassandraHash
  class CassandraStore
    def initialize(*args)
      @connection = Cassandra.new(*args)
    end
    # Get takes the class name of an object and its key; 
    #      and returns the attributes
    
    # @param [String]
    # @return [Hash]
    def get(name, key)
      @connection.get(name, key)
    end
    
    # Set saves takes the class name of an object and its key; 
    #      and returns the attributes
    
    # @param [String], [String], [EncodedHash]
    # @return [EncodedHash]
    def set(name, key, attributes)
      @connection.set(name, key, attributes)
    end
  end
end