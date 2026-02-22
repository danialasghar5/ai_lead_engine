class LeadsController < ApplicationController
  before_action :set_lead, only: [:show]

  def index
    @leads = Lead.order(created_at: :desc)
  end

  def show
  end

  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(lead_params)
    if @lead.save
      AnalyzeLeadJob.perform_later(@lead.id)
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Lead submitted successfully." }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_lead
    @lead = Lead.find(params[:id])
  end

  def lead_params
    params.require(:lead).permit(:name, :email, :message)
  end
end