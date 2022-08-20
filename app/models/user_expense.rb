class UserExpense < ApplicationRecord
  belongs_to :user
  belongs_to :expense
  has_one :payment_status
  scope :paid, -> { where(:paid => true)}
  scope :unpaid, -> { where(:paid => false)}

  # Ex:- scope :active, -> {where(:active => true)}
end
