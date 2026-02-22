class Lead < ApplicationRecord
  validates :name, :email, :message, presence: true

  enum ai_status: {
    pending: "pending",
    completed: "completed",
    failed: "failed"
  }
end