ActiveRecord::Schema.define() do

  create_table :accounts, :force => true do |t|
    t.integer :value_cents, :total_cents
    t.string  :value_currency, :total_currency
  end

  create_table :products, :force => true do |t|
    t.integer :value_cents, :tax_pennys
    t.string  :value_currency
  end


end
