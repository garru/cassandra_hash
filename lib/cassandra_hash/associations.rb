module CassandraHash
  module Associations
    def has_one(association_name, options = {})
       klass = options[:class]
       self.class_eval <<-eos
        def #{association_name}
          @associations["#{association_name}"] ||= #{klass}[key]
        end
        
        def #{association_name}=(attributes)
          #{association_name}.attributes = attributes
          #{association_name}
        end
       eos
    end
  end
end