require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'CassandraHash' do
  describe 'WriteThrough' do  
    before :all do
      accessor = CassandraHash::Accessor::MockStore.new
      $memcache = Cash::Mock.new
      write_through = CassandraHash::Accessor::WriteThrough.new(accessor, {:repository => $memcache})
      CassandraHash::Base.finder = CassandraHash::Finder.new(write_through)
    end
    
    describe '#[]' do
      describe 'write through save' do
        it 'should save to cache after persistent write' do
          user = User['1']          
          user['ping'] = 'pong'
          lambda{$memcache.get("/User/1")}.should raise_error(Memcached::NotFound)
          user.save
          $memcache.get("/User/1").should == user.attributes
        end
      end
      
      describe 'if cache is not populated' do
        it 'should populate cache on read' do
          user = User['1']          
          user['ping'] = 'pong'
          user.save
          $memcache.flush_all
          user = User['1'] 
          $memcache.get("/User/1").should == user.attributes
        end
      end
    end
  end
end
