require 'rails_helper'

RSpec.describe Lead, type: :model do
  describe 'validations' do
    it 'is valid with a name, email, and message' do
      lead = Lead.new(
        name: 'John Doe',
        email: 'john@example.com',
        message: 'I need pricing details.'
      )
      expect(lead).to be_valid
    end

    it 'is invalid without a name' do
      lead = Lead.new(name: nil, email: 'john@example.com', message: 'Hi')
      expect(lead).not_to be_valid
      expect(lead.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      lead = Lead.new(name: 'John', email: nil, message: 'Hi')
      expect(lead).not_to be_valid
      expect(lead.errors[:email]).to include("can't be blank")
    end

    it 'is invalid without a message' do
      lead = Lead.new(name: 'John', email: 'john@example.com', message: nil)
      expect(lead).not_to be_valid
      expect(lead.errors[:message]).to include("can't be blank")
    end
  end

  describe 'enums' do
    it 'defines ai_status states correctly' do
      expect(Lead.ai_statuses.keys).to match_array(%w[pending completed failed])
    end

    it 'defaults ai_status to pending' do
      lead = Lead.new
      expect(lead.ai_status).to eq('pending')
    end
  end
end
