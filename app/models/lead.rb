class Lead < ApplicationRecord
  after_create_commit -> { broadcast_prepend_to "leads" }
  after_update_commit -> { broadcast_replace_to "leads" if saved_change_to_ai_status? }
  validates :name, :email, :message, presence: true

  enum :ai_status, { pending: 0, completed: 1, failed: 2 }
end