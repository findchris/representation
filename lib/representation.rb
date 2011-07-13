require 'active_support'

module Representation
  extend ActiveSupport::Concern
  
  included do
    class_attribute :representations
    self.representations = {}
  end

  module ClassMethods
    def representation(name, *attributes_and_method_names)
      representations[name] = attributes_and_method_names
    end
  end

  module InstanceMethods
    def representation(name)
      represented_object = clone
      represented_object
    end
  end
end