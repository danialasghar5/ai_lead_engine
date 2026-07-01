require 'rails_helper'

RSpec.describe LeadAnalyzer do
  let(:message) { 'Need a secure API gateway migration quote.' }
  let(:analyzer) { described_class.new(message: message) }
  let(:mock_client) { instance_double(OpenRouter::Client) }

  before do
    allow(OpenRouter::Client).to receive(:new).and_return(mock_client)
    # Ensure config key setup doesn't fail if undefined
    allow(Rails.application.config.x).to receive_message_chain(:openrouter, :model).and_return('openai/gpt-4o-mini')
  end

  describe '#call' do
    context 'when the API call is successful' do
      let(:api_response) do
        {
          'choices' => [
            {
              'message' => {
                'content' => {
                  'summary' => 'Enterprise customer requesting migration API gateway quote.',
                  'intent' => 'hot',
                  'urgency' => 'High',
                  'lead_score' => 9
                }.to_json
              }
            }
          ]
        }
      end

      it 'returns a parsed hash of lead qualification details' do
        expect(mock_client).to receive(:complete).with(
          [
            { role: 'system', content: a_string_including('lead_score') },
            { role: 'user', content: message }
          ],
          model: 'openai/gpt-4o-mini',
          extras: {
            temperature: 0.2,
            response_format: { type: 'json_object' }
          }
        ).and_return(api_response)

        result = analyzer.call

        expect(result).to eq({
          'summary' => 'Enterprise customer requesting migration API gateway quote.',
          'intent' => 'hot',
          'urgency' => 'High',
          'lead_score' => 9
        })
      end
    end

    context 'when the API call returns invalid JSON' do
      let(:invalid_response) do
        {
          'choices' => [
            {
              'message' => {
                'content' => 'not-json-content'
              }
            }
          ]
        }
      end

      it 'rescues parse errors and returns nil' do
        allow(mock_client).to receive(:complete).and_return(invalid_response)
        expect(analyzer.call).to be_nil
      end
    end

    context 'when the API client raises an exception' do
      it 'rescues the exception, logs it, and returns nil' do
        allow(mock_client).to receive(:complete).and_raise(StandardError.new('API connection timeout'))
        expect(Rails.logger).to receive(:error).with(/API connection timeout/)
        
        expect(analyzer.call).to be_nil
      end
    end
  end
end
