unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
end

require 'rubygems'
require 'json'
require 'cassandra_hash/base'
require 'cassandra_hash/finder'
require 'cassandra_hash/identity_map'
require 'cassandra_hash/serialization'
require 'cassandra_hash/serializer/json_serializer'
require 'cassandra_hash/accessor/abstract'
require 'cassandra_hash/accessor/mock_store'
require 'cassandra_hash/accessor/cassandra_store'