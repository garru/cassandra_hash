require 'json'
module CassandraHash
  class JSONSerializer
    def encode(attribute)
      attribute.to_json
    end
    
    def decode(attribute)
      begin
        JSON.parse(attribute)
      rescue ::JSON::ParserError
        attri = JSON.parse("\{\"a\"\:#{attribute}}")
        attri["a"]
      end
    end
  end
end