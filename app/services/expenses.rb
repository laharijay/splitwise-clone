class Expenses
  def get_user_sharing_expenses(user)
    @user_expenses = user.expenses.all
    data = []
    expenses = []
    data_hash = {}
    @user_expenses.each do |expense|
      expense_data = {}
      user_count = expense.users.count
      slipted_amount = (expense.amount.to_i / user_count)
      expense_details = []
      user_name = expense.users.each do |user|
        user_data = {}
        user_data[:name]  = user.name
        user_data[:splited_amount] = slipted_amount
        expense_details<< user_data
      end
      data<< expense_details
      expenses<< expense
    end
    data_hash[:expense_details]  = data
    data_hash[:expenses] = expenses
    data_hash
  end
  
  def get_expense(expense)
    expenses_detail = []
    # user_count = expense.users.count
    # slipted_amount = ((expense.amount.to_i + expense.tax_amount.to_i) / user_count)
    user_name = expense.user_expenses.each do |user_expense|
      user_data = {}
      user_data[:name]  = user_expense.user.name
      user_data[:splited_amount] = user_expense.splited_amount
      expenses_detail<< user_data
    end
    expenses_detail
  end
   
end