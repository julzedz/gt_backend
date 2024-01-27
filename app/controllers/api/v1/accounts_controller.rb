class Api::V1::AccountsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :update]

# GET /api/v1/accounts
  def index
    @accounts = current_user.account

    render json: @accounts, include: [:user]
  end

# GET /api/v1/accounts/:id
  def show
    @account = Account.find(params[:id])

    render json: @account, include: [:user]
  end

# POST /api/v1/accounts
  def create
    @account = current_user.build_account(account_params)

    if @account.save
      render json: @account, status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

# PATCH /api/v1/accounts/:id
  def update
    @account = Account.find(params[:id])

    if params[:amount].present?
      new_balance = @account.savings_account.to_f + params[:amount].to_f
      if @account.update(savings_account: new_balance)
        render json: @account, include: [:user], status: :ok
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end

    if params[:sum].present?
      new_sum = @account.stakes.to_f + params[:sum].to_f
      if @account.update(stakes: new_sum)
        render json: @account, include: [:user], status: :ok
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end

    if params[:addinvest].present?
      new_invest = @account.investment.to_f + params[:addinvest].to_f
      if @account.update(investment: new_invest)
        render json: @account, include: [:user], status: :ok
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end
  end

  private

# Whitelist permissible params
    def account_params
      params.require(:account).permit(:savings_account, :investment, :earnings, :stakes)
    end
  end
