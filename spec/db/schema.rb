require File.dirname(__FILE__) + '/../spec_helper.rb'

#add some postgis specific tables
ActiveRecord::Schema.define() do

  create_table :accounts, :force => true do |t|
    t.integer :value
  end



end
