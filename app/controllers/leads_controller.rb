class LeadsController < ApplicationController
  def index
    @leads = Lead.order(created_at: :desc)
  end

  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(lead_params)

    if @lead.save
      AnalyzeLeadJob.perform_later(@lead.id)
      redirect_to root_path, notice: "Lead submitted successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :email, :message)
  end
end