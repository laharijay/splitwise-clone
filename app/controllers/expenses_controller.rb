class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[ show edit]

  # GET /my_expenses or /my_expenses.json
  def my_expenses
   @my_expenses = current_user.user_expenses
  end

  # GET /sharing_expenses or /sharing_expenses.json
  def sharing_expenses
    begin
      sharing_expenses = Expenses.new.get_user_sharing_expenses(current_user)
      @data = sharing_expenses[:expense_details]
      @expenses = sharing_expenses[:expenses]
    rescue=>e
      raise e
    end
  end

  # GET /friend_expenses or /friend_expenses.json
  def friend_expenses
    @friend_expenses = UserExpense.where.not(user_id: current_user.id)
  end

  # GET /expenses/1 or /expenses/1.json
  def show
    @expenses_detail = Expenses.new.get_expense(@expense)
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    @users = User.all
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses or /expenses.json
  def create
    users = params[:expense][:id].compact_blank
    splited_amount = (expense_params[:amount].to_i + expense_params[:tax_amount].to_i) / (users.count + 1)
    @expense = Expense.new(expense_params)
    respond_to do |format|
      if @expense.save
        user_expense = current_user.user_expenses.create(expense_id: @expense.id, splited_amount: splited_amount, paid: true)
        users.each do |user_id|
          user_expense = UserExpense.create(user_id: user_id, expense_id: @expense.id, splited_amount: splited_amount)
        end
          format.html { redirect_to root_path, notice: "Expense was successfully created." }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def set_payment_status
    user_expense = UserExpense.find (params[:id])
    respond_to do |format|
      if user_expense.update(paid: true)
        format.html { redirect_to root_path, notice: "Expense was successfully updated." }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @expense = Expense.find params[:id]
    splite_valid_amount
    respond_to do |format|
      @expense.user_expenses.each_with_index do |user_expense, index|
        if user_expense.update(splited_amount: params[:share_amount]["#{index}"]["splited_amount"])

          format.json { render :show, status: :ok, location: user_expense  }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json:  user_expense.errors, status: :unprocessable_entity }
        end
      end
      format.html { redirect_to root_path, notice: "Expense was successfully updated." }
    
    end
  end

  private
    # splited amount should be equal to total  spend amount
    def splite_valid_amount
      total_shared_amount = 0.0
      @expense.user_expenses.each_with_index do |user_expense, index|
        total_shared_amount += params[:share_amount]["#{index}"]["splited_amount"].to_i
      end
      total_shared_amount
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.require(:expense).permit(:amount, :description, :tax_amount, :share_amount)
    end
end
