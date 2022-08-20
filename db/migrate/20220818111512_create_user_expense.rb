class CreateUserExpense < ActiveRecord::Migration[6.1]
  def change
    create_table :user_expenses do |t|
      t.references :user, null: false, foreign_key: true, optional: true
      t.references :expense, null: false, foreign_key: true
      t.timestamps
    end
  end
end
