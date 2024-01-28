class Api::V1::AccountsController < ApplicationController
  before_action :authenticate_with_token!, except: [:create]

# GET /api/v1/accounts
  def index
    @accounts = current_user.account

    render json: @accounts
  end

# GET /api/v1/accounts/:id
  def show
    @account = Account.find(params[:id])

    render json: @account
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

  updates = {}

  if params[:amount].present?
    updates[:savings_account] = @account.savings_account.to_f + params[:amount].to_f
  end

  if params[:sum].present?
    updates[:stakes] = @account.stakes.to_f + params[:sum].to_f
  end

  if params[:addinvest].present?
    updates[:investment] = @account.investment.to_f + params[:addinvest].to_f
  end

  if params[:file].present?
    @account.payment_receipt.attach(params[:file])
    if @account.payment_receipt.attached?
      updates[:payment_receipt] = @account.payment_receipt
    end
  end

  if updates.present?
    if @account.update(updates)
      render json: @account, status: :ok
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  else
    render json: { error: 'No updates provided' }, status: :bad_request
  end
end

  private

# Whitelist permissible params
    def account_params
      params.require(:account).permit(:savings_account, :investment, :earnings, :stakes)
    end
  end
