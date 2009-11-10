unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
end

require 'rubygems'
require 'json'
require 'cassandra_hash/base'
require 'cassandra_hash/persistence'
require 'cassandra_hash/serialization'
require 'cassandra_hash/serializer/json_serializer'
require 'cassandra_hash/persistence/mock_store'
require 'cassandra_hash/persistence/cassandra_store'