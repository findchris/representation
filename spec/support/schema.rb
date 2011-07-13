ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.string  :name
    t.integer :age
    t.string  :ssn
    t.timestamps
  end
end