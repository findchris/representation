require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ruby-debug'

describe "Representation" do
  context "the module" do
    it "should be includable" do
      class Dummy
        include Representation
      end
    end
    it "should make available the representation class method" do
      class Dummy
        include Representation        
        representation :ignored, :ignored
        attr_accessor :ignored
      end
    end
    it "should make available the representation instance method" do
      class Dummy
        include Representation        
        representation :ignored, :ignored
        attr_accessor :ignored
      end
      Dummy.new.representation(:ignored)
    end
  end
  context ".representation" do
    it "should accept the name of the representation as the first argument" do
      class Dummy
        include Representation        
        representation :public, :ignored
      end
      Dummy.representation_names.should include(:public)
    end
    it "should accept a list of attributes and method names that make up the named representation" do
      class Dummy
        include Representation        
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
  end
end
