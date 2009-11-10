require 'json'
module CassandraHash
  class JSONSerializer
    def encode(attribute)
      if attribute.is_a?(String) || attribute.is_a?(Numeric)
        attribute
      else
        attribute.to_json
      end
    end
    
    def decode(attribute)
      begin
        JSON.parse(attribute)
      rescue ::JSON::ParserError
        attribute
      end
    end
  end
end