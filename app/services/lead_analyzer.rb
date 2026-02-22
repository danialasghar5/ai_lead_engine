class LeadAnalyzer
  def initialize(message:)
    @message = message
  end

  def call
    response = client.complete(
      messages,
      model: Rails.application.config.x.openrouter.model,
      extras: {
        temperature: 0.2,
        response_format: { type: "json_object" }
      }
    )

    parse(response)
  rescue => e
    Rails.logger.error("AI Error: #{e.message}")
    nil
  end

  private

  def client
    @client ||= OpenRouter::Client.new
  end

  def messages
    [
      {
        role: "system",
        content: system_prompt
      },
      {
        role: "user",
        content: @message
      }
    ]
  end

  def system_prompt
    <<~PROMPT
      You are a business lead analysis assistant.

      Return valid JSON only:

      {
        "summary": "short summary",
        "intent": "category",
        "urgency": "Low | Medium | High",
        "lead_score": number 1 to 10
      }
    PROMPT
  end

  def parse(response)
    content = response.dig("choices", 0, "message", "content")
    JSON.parse(content)
  rescue JSON::ParserError
    nil
  end
end