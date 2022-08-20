class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.decimal :amount
      t.text :description
      t.decimal :tax_amount
    end
  end
end
