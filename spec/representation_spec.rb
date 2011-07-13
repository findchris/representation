require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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
      end
    end
    it "should make available the representation instance method" do
      class Dummy
        include Representation        
        representation :ignored, :ignored
      end
      Dummy.new.representation(:ignored)
    end
  end
  context ".representation" do
    it "should accept the name of the representation as the first argument" do
      class Dummy
        include Representation        
        representation :public
      end
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
    end
  end
  context "#representation" do
    it "should return the same type of object as the receiver" do
      class Dummy
        include Representation        
        representation :public, :name, :calculated_age
        
        attr_accessor :name, :age
        
        def calculated_age
          age * 2
        end
      end
      
      dummy = Dummy.new
      dummy.representation(:public).should be_an_instance_of(Dummy)
    end
    it "should return an object with only the attributes identified by the representation definition" do
      class Dummy
        include Representation        
        representation :public, :name, :calculated_age

        attr_accessor :name, :age, :ssn

        def calculated_age
          age * 2
        end
      end

      dummy = Dummy.new
      dummy.name = 'Tweedle Dum'
      dummy.age  = 42
      public_dummy = dummy.representation(:public)
      public_dummy.name.should == 'Tweedle Dum'
      public_dummy.calculated_age.should == 84
      lambda { public_dummy.ssn }.should raise_error(NoMethodError)
    end
  end
end
