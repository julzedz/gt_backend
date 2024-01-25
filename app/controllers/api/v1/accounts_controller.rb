class Api::V1::AccountsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

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
    @account = current_user.account

    if @account.update(account_params)
      render json: @account, include: [:user]
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  private

# Whitelist permissible params
  def account_params
    params.permit(:savings_account, :investment, :earnings, :stakes)
  end

end
