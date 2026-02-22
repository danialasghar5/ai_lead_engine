class AnalyzeLeadJob < ApplicationJob
  queue_as :default

  def perform(lead_id)
    lead = Lead.find_by(id: lead_id)
    return unless lead

    result = LeadAnalyzer.new(message: lead.message).call

    if result.present?
      lead.update(
        summary: result["summary"],
        intent: result["intent"],
        urgency: result["urgency"],
        lead_score: result["lead_score"],
        ai_status: "completed"
      )
    else
      lead.update(ai_status: "failed")
    end

  end
end