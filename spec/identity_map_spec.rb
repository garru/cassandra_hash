require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'CassandraHash' do
  describe 'IdentityMap' do  
    before :all do
      CassandraHash::Base.finder = CassandraHash::IdentityMap.new(CassandraHash::Finder.new(CassandraHash::Accessor::MockStore.new))
      CassandraHash::Base.clear_session
    end
    
    describe '#[]' do
      describe 'when the object does not yet exist' do
        it 'returns an empty object with the key set' do
          user_1 = User['2']
          user_2 = User['2']
          user_1.attributes.should == user_2.attributes
          user_1['ping'] = 'pong'
          user_1.attributes.should == user_2.attributes
          user_1.id.should == user_2.id
        end
      end
    end
  end
end
