class User < ActiveRecord::Base
  include Representation        
  representation :public, :name, :calculated_age

  def calculated_age
    age * 2
  end
end