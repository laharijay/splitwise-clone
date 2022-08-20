class AddPaymentStatusTUserExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :user_expenses, :paid, :boolean, default: false
    add_column :user_expenses, :splited_amount, :decimal
  end
end
