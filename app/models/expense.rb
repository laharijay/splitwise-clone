class Expense < ApplicationRecord
    has_many :user_expenses
    has_many :users, through: :user_expenses   
   
    def set_payment_status
      self.update
    end
end
