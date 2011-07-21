require 'active_record'

module Representation
  
  class UnknownRepresentationError < StandardError; end
  
  module ActiveRecord
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
        raise UnknownRepresentationError, "Unknown Representation '#{name}'" unless representation_names.include?(name)
        representations[name]
      end
    end

    module InstanceMethods
      def representation(name)
        attributes_and_method_names = self.class.values_for_representation(name)
        represented_attributes = attributes_and_method_names.inject({}) do |attributes, val|
          attributes.merge({val.to_s => send(val)})
        end

        clone.tap do |represented_object|
          represented_object.instance_variable_set('@attributes', represented_attributes)
        
          represented_attributes.each do |key, value|
            represented_object.singleton_class.send :attr_accessor, key.to_sym
            represented_object.send "#{key}=".to_sym, value
          end
        
          def represented_object.attributes
            @attributes
          end
        
          def represented_object.inspect
            attributes_as_nice_string = @attributes.keys.map {|name| "#{name}: #{attribute_for_inspect(name)}"}
            "#<#{self.class} #{attributes_as_nice_string.compact.join(", ")}>"
          end
        end
      end
      
      alias_method :as, :representation
    end
  end
end