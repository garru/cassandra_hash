require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'CassandraHash' do
  describe 'Base' do
    describe '#[]' do
      describe 'when the object does not yet exist' do
        it 'returns an empty object with the key set' do
          user = User['1']
          user.attributes.should == {}
          user.key.should == '1'
        end
      end
    
      describe 'when the object exists' do
        it 'returns that object' do 
          attributes = {"name" => "Gary", "birthday" => "June 23"}
          User['2'] = attributes
          user = User['2']
          user.key.should == '2'
          user.attributes.should == attributes
        end
      end
      
      describe 'when setting the object' do
        it 'should handle Arrays' do 
          attributes = {"name" => "Gary", "birthday" => "June 23", 
              "comments" => ["blah1", "blah2", "blah3"]}
          User['2'] = attributes
          user = User['2']
          user.key.should == '2'
          user.attributes.should == attributes
        end
        
        it 'should handle Hashes' do 
          attributes = {"name" => "Gary", "birthday" => "June 23", 
              "position" => {"x" => 1, "y" => 2, "z" => 3}}
          User['2'] = attributes
          user = User['2']
          user.key.should == '2'
          user.attributes.should == attributes
        end
      end
    end
    
    describe '#column_family_name' do
      it "should use overwritten column family" do
        Toys.column_family_name.should == 'NotFunToys'
      end
      
      it "should use default column family when none is provided" do
        User.column_family_name.should == 'User'
      end
    end
  end
end
