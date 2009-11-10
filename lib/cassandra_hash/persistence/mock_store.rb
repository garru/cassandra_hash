module CassandraHash
  # Persistence Stores need to support 2 methods.
  class MockStore
    def initialize
      @classes = Hash.new{|h,k| h[k] = {}}
    end
    # Get takes the class name of an object and its key; 
    #      and returns the attributes
    
    # @param [String]
    # @return [Hash]
    def get(name, key)
      @classes[name][key] || {}
    end
    
    # Set saves takes the class name of an object and its key; 
    #      and returns the attributes
    
    # @param [String], [String], [EncodedHash]
    # @return [EncodedHash]
    def set(name, key, attributes)
      @classes[name][key] = attributes
    end
  end
end