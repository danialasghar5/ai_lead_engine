class CreateLeads < ActiveRecord::Migration[8.1]
  def change
    create_table :leads do |t|
      t.string :name
      t.string :email
      t.text :message
      t.text :summary
      t.string :intent
      t.string :urgency
      t.integer :lead_score
      t.string :ai_status, default: "pending"

      t.timestamps
    end
  end
end
