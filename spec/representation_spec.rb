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
        representation
      end
    end
    it "should make available the representation instance method" do
      class Dummy
        include Representation        
        representation
      end
      Dummy.new.representation
    end
  end
end
