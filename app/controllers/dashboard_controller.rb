class DashboardController < ApplicationController
  def dashboard
    @users = User.where.not(id: current_user)
    @user_expenses = current_user.user_expenses.unpaid
    @total_owed =  current_user.user_expenses.paid.pluck(:splited_amount).sum
    @total_owe =  current_user.user_expenses.unpaid.pluck(:splited_amount).sum
  end
end
