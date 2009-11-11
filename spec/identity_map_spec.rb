require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'CassandraHash' do
  describe 'IdentityMap' do  
    before :all do
      CassandraHash::Base.finder = CassandraHash::IdentityMap.new(CassandraHash::Finder.new(CassandraHash::Accessor::MockStore.new))
      CassandraHash::Base.clear_session
    end
    
    describe '#[]' do
      describe 'when you call the accessor twice' do
        it 'should always return the same object' do
          user_1 = User['2']
          user_2 = User['2']
          user_1.attributes.should == user_2.attributes
          user_1['ping'] = 'pong'
          user_1.attributes.should == user_2.attributes
          user_1.object_id.should == user_2.object_id
        end
      end
    end
    
    describe '#clear_session' do
      it 'should clear identity map' do
        user_1 = User['2']
        user_2 = User['2']
        user_1.attributes.should == user_2.attributes
        user_1['ping'] = 'pong'
        user_1.attributes.should == user_2.attributes
        user_1.object_id.should == user_2.object_id
        CassandraHash::Base.clear_session
        user_3 = User['2']
        user_3.attributes.should == {}
      end
    end
  end
end
