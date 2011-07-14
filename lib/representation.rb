require 'representation/active_record'
ActiveRecord::Base.send :include, Representation::ActiveRecord

# TODO:  Maybe use a Railtie, e.g.:
# module Representation
#   class Railtie < Rails::Railtie
#     initializer "representation.active_record" do
#       ActiveSupport.on_load :active_record do
#         require 'representation/active_record'
#         include Representation::ActiveRecord
#       end
#     end
#   end
# end