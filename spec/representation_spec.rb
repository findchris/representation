require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ruby-debug'

describe "Representation" do
  context "the ActiveRecord module" do
    it "should be includable" do
      class Dummy
        include Representation::ActiveRecord
      end
    end
    it "should make available the representation class method" do
      class Dummy
        include Representation::ActiveRecord       
        representation :ignored, :ignored
        attr_accessor :ignored
      end
    end
    it "should make available the representation instance method" do
      class Dummy
        include Representation::ActiveRecord     
        representation :ignored, :ignored
        attr_accessor :ignored
      end
      Dummy.new.representation(:ignored)
    end
  end
  context ".representation" do
    it "should accept the name of the representation as the first argument" do
      class Dummy
        include Representation::ActiveRecord        
        representation :public, :ignored
      end
      Dummy.representation_names.should include(:public)
    end
    it "should accept a list of attributes and method names that make up the named representation" do
      class Dummy
        include Representation::ActiveRecord 
        representation :public, :name, :calculated_age
        
        attr_accessor :name, :age
        
        def calculated_age
          age * 2
        end
      end
      Dummy.values_for_representation(:public).should == [:name, :calculated_age]
    end
  end
  context "#representation" do
    it "should return the same type of object as the receiver" do
      user = User.new(:age => 42)
      user.representation(:public).should be_an_instance_of(User)
    end
    it "should return an object with only the attributes identified by the representation definition" do
      user = User.new(:name => 'Tweedle Dum', :age => 42)
      public_user = user.representation(:public)
      
      public_user.name.should == 'Tweedle Dum'
      public_user.calculated_age.should == 84
      lambda { public_user.ssn }.should raise_error(NoMethodError)
    end
  end
  context "when working with the representation object" do
    it "should print an accurate #inspect string" do
      user = User.new(:name => 'Tweedle Dum', :age => 42)
      public_user = user.representation(:public)
      public_user.inspect.should == '#<User name: "Tweedle Dum", calculated_age: 84>'
    end
    it "should have the @attributes ivar set correctly" do
      user = User.new(:name => 'Tweedle Dum', :age => 42)
      public_user = user.representation(:public)
      public_user.instance_variable_get('@attributes').should == {'name' => 'Tweedle Dum', 'calculated_age' => 84}
    end
    it "should have have the #attributes method defined correctly" do
      user = User.new(:name => 'Tweedle Dum', :age => 42)
      public_user = user.representation(:public)
      public_user.attributes.should == {'name' => 'Tweedle Dum', 'calculated_age' => 84}
    end
    it "should have attr_accessors set for each attribute of the representation" do
      user = User.new(:name => 'Tweedle Dum', :age => 42)
      public_user = user.representation(:public)
      public_user.should respond_to(:name=)
      public_user.name.should == 'Tweedle Dum'
      public_user.should respond_to(:calculated_age=)
      public_user.calculated_age.should == 84      
    end
    it "should allow multiple representations" do
      user = User.create!(:name => 'Tweedle Dum', :age => 42, :ssn => '555-55-5555')
      public_user = user.representation(:public)
      internal_user = user.representation(:internal)
      public_user.attributes.should == {'name' => 'Tweedle Dum', 'calculated_age' => 84}
      internal_user.attributes.should == {'id' => 1, 'name' => 'Tweedle Dum', 'age' => 42, 'ssn' => '555-55-5555'}
    end
    it "should respond to to_json" do
      user = User.new(:name => 'Tweedle Dum', :age => 42)
      public_user = user.representation(:public)
      public_user.should respond_to :to_json
    end
    it "should respond to to_xml" do
      user = User.new(:name => 'Tweedle Dum', :age => 42)
      public_user = user.representation(:public)
      public_user.should respond_to :to_xml
    end
    it "should respond to as_json" do
      user = User.new(:name => 'Tweedle Dum', :age => 42)
      public_user = user.representation(:public)
      public_user.should respond_to :as_json
    end
    it "should respond to serializable_hash" do
      user = User.new(:name => 'Tweedle Dum', :age => 42)
      public_user = user.representation(:public)
      public_user.should respond_to :serializable_hash
    end
    it "should not modify the resource off of which the representation is based" do
      user = User.new(:name => 'Tweedle Dum', :age => 42)
      public_user = user.representation(:public)
      public_user.name = 'Tweedle Dee'
      user.name.should == 'Tweedle Dum'
    end
    it "should raise a Representation::UnknownRepresentationError when referencing an unknown representation" do
      user = User.new(:name => 'Tweedle Dum', :age => 42)
      lambda { user.representation(:invalid) }.should raise_error Representation::UnknownRepresentationError
    end
  end
  context "ActiveRecord" do
    it "should include the Representation module into ActiveRecord" do
      class SomeModel < ActiveRecord::Base; end
      SomeModel.should respond_to :representation
    end
  end
end
