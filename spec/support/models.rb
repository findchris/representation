class User < ActiveRecord::Base
  include Representation        
  representation :public, :name, :calculated_age
  representation :internal, :id, :name, :ssn, :age

  def calculated_age
    age * 2
  end
end