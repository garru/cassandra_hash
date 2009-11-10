$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'cassandra_hash'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.mock_with :rr
  config.before :suite do
    CassandraHash::Base.persistence_store = CassandraHash::MockStore.new
    CassandraHash::Base.serializer = CassandraHash::JSONSerializer.new
    User = Class.new(CassandraHash::Base)
  end
end
