require 'rails_helper'

RSpec.describe 'Leads', type: :request do
  describe 'GET /leads' do
    it 'returns a successful response' do
      get leads_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /leads/new' do
    it 'returns a successful response' do
      get new_lead_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /leads' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          lead: {
            name: 'Sarah Jenkins',
            email: 'sarah@enterprise.com',
            message: 'Looking for a secure gateway partner.'
          }
        }
      end

      it 'creates a new Lead record' do
        expect {
          post leads_path, params: valid_params
        }.to change(Lead, :count).by(1)
      end

      it 'enqueues the AnalyzeLeadJob' do
        expect {
          post leads_path, params: valid_params
        }.to have_enqueued_job(AnalyzeLeadJob)
      end

      it 'redirects to root path with a success notice' do
        post leads_path, params: valid_params
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Lead submitted successfully.')
      end

      it 'handles turbo_stream format response' do
        post leads_path, params: valid_params, as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          lead: {
            name: '',
            email: '',
            message: ''
          }
        }
      end

      it 'does not create a new Lead' do
        expect {
          post leads_path, params: invalid_params
        }.not_to change(Lead, :count)
      end

      it 'returns an unprocessable entity status' do
        post leads_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
