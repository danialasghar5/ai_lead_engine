OpenRouter.configure do |config|
  config.access_token = Rails.application.credentials.dig(:openrouter, :api_key) || ENV["OPENROUTER_API_KEY"]
end

Rails.application.config.x.openrouter.model = ENV.fetch("OPENROUTER_MODEL", "openai/gpt-4o-mini")
