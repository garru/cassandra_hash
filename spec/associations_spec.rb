require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'CassandraHash' do
  describe 'Associations' do  
    before :all do
      CassandraHash::Base.finder = CassandraHash::Finder.new(CassandraHash::Accessor::MockStore.new)
    end
    
    describe '#has_one' do
      it 'creates association methods' do
        user = User['1']
        user.toys = {"awesome toys" => "voltron"}
        Toys['1'].attributes.should == {}
        user.toys.attributes.should == {"awesome toys" => "voltron"}
        user.save
        Toys['1'].attributes.should == user.toys.attributes
      end
    end
  end
end
