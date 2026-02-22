class Lead < ApplicationRecord
  validates :name, :email, :message, presence: true

  enum :ai_status, { pending: 0, completed: 1, failed: 2 }
end