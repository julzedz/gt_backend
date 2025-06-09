module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :authenticate_request
      before_action :set_transaction, only: [:show, :download_receipt]

      def index
        @transactions = current_user.transactions.order(created_at: :desc)
        render json: @transactions
      end

      def show
        render json: @transaction
      end

      def create
        @transaction = current_user.transactions.build(transaction_params)
        
        if @transaction.save
          # Generate PDF receipt
          receipt_path = generate_receipt(@transaction)
          
          render json: {
            transaction: @transaction,
            receipt_url: receipt_path
          }, status: :created
        else
          render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def download_receipt
        receipt_path = generate_receipt(@transaction)
        
        if File.exist?(receipt_path)
          send_file receipt_path,
                    filename: "transaction_receipt_#{@transaction.reference_id}.pdf",
                    type: "application/pdf",
                    disposition: "attachment"
        else
          render json: { error: "Receipt not found" }, status: :not_found
        end
      end

      private

      def set_transaction
        @transaction = current_user.transactions.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Transaction not found" }, status: :not_found
      end

      def transaction_params
        params.require(:transaction).permit(:amount, :transaction_type, :description)
      end

      def generate_receipt(transaction)
        # Create receipts directory if it doesn't exist
        FileUtils.mkdir_p(Rails.root.join('public', 'receipts'))

        # Generate PDF using TransactionReceiptPdf service
        receipt_path = Rails.root.join('public', 'receipts', "receipt_#{transaction.reference_id}.pdf")
        pdf = TransactionReceiptPdf.new(transaction)
        pdf.render_file(receipt_path)

        # Return the relative path for the frontend
        "/receipts/receipt_#{transaction.reference_id}.pdf"
      end
    end
  end
end