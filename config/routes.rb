Rails.application.routes.draw do
  resources :expenses
  get 'my_expenses', to: 'expenses#my_expenses'
  get 'sharing_expenses', to: 'expenses#sharing_expenses'
  put 'set_payment_status', to: "expenses#set_payment_status"
  get 'friend_expenses', to: 'expenses#friend_expenses'
  resources :people
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "dashboard#dashboard"
end
