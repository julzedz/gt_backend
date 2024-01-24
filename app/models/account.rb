class Account < ApplicationRecord
  belongs_to :user
  after_create :set_default_values

private

  def set_default_values
    self.update_columns(savings_account: 0.00, investment: 0.00, earnings: 0.00, stakes: 0.00)
  end
end
