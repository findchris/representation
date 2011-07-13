require 'active_record'

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
    def representation_names
      representations.keys
    end
    def values_for_representation(name)
      representations[name]
    end
  end

  module InstanceMethods
    def representation(name)
      represented_attributes = self.class.values_for_representation(name).inject({}) do |attributes, val|
        attributes.merge({val.to_s => send(val)})
      end
      
      clone.tap do |represented_object|
        represented_object.instance_variable_set('@attributes', represented_attributes)
        
        def represented_object.attributes
          represented_attributes
        end
        
        def represented_object.inspect
          attributes_as_nice_string = @attributes.keys.map {|name| "#{name}: #{attribute_for_inspect(name)}"}
          "#<#{self.class} #{attributes_as_nice_string.compact.join(", ")}>"
        end
      end
    end
    
  end
end