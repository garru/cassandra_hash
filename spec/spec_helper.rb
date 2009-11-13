$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'cassandra_hash'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.mock_with :rr
  User = Class.new(CassandraHash::Base)
  Toys = Class.new(CassandraHash::Base)  
  Toys.class_eval do
    column_family "NotFunToys"
  end
  
  User.class_eval do
    has_one :toys, :class => Toys
  end
end
