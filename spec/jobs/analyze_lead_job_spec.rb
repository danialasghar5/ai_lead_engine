require 'rails_helper'

RSpec.describe AnalyzeLeadJob, type: :job do
  let!(:lead) { Lead.create!(name: 'Jane', email: 'jane@example.com', message: 'Need urgent help!') }
  let(:mock_analyzer) { instance_double(LeadAnalyzer) }

  before do
    allow(LeadAnalyzer).to receive(:new).with(message: lead.message).and_return(mock_analyzer)
  end

  describe '#perform' do
    context 'when lead is successfully analyzed' do
      let(:analysis_result) do
        {
          'summary' => 'Urgent support request.',
          'intent' => 'hot',
          'urgency' => 'High',
          'lead_score' => 10
        }
      end

      it 'updates the lead with analyzed attributes and marks status as completed' do
        expect(mock_analyzer).to receive(:call).and_return(analysis_result)

        described_class.new.perform(lead.id)

        lead.reload
        expect(lead.summary).to eq('Urgent support request.')
        expect(lead.intent).to eq('hot')
        expect(lead.urgency).to eq('High')
        expect(lead.lead_score).to eq(10)
        expect(lead.ai_status).to eq('completed')
      end
    end

    context 'when lead analysis fails' do
      it 'marks the lead status as failed' do
        expect(mock_analyzer).to receive(:call).and_return(nil)

        described_class.new.perform(lead.id)

        lead.reload
        expect(lead.ai_status).to eq('failed')
        expect(lead.summary).to be_nil
      end
    end

    context 'when lead does not exist' do
      it 'completes without raising errors' do
        expect(LeadAnalyzer).not_to receive(:new)
        expect {
          described_class.new.perform(999999)
        }.not_to raise_error
      end
    end
  end
end
