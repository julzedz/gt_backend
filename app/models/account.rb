class Account < ApplicationRecord
  belongs_to :user
  after_create :set_default_values
  # has_one_attached :payment_receipt

  validates :savings_account, :investment, :earnings, :stakes, presence: true
  validates :savings_account, :investment, :earnings, :stakes, numericality: { greater_than_or_equal_to: 0 }

private

  def set_default_values
    self.update_columns(savings_account: 0.00, investment: 0.00, earnings: 0.00, stakes: 0.00)
  end
end
