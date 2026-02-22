# AI Lead Engine

AI Lead Engine is a Rails 8 application that automatically processes and analyzes incoming business leads using AI via [OpenRouter](https://openrouter.ai/). 

Whenever a new lead is submitted, the application offloads the text analysis to a background job, which parses the message for its intended category, urgency level, and scores the lead from 1 to 10. Once the analysis is successfully completed by OpenRouter's LLM, the results are seamlessly broadcasted back to the user's view in real-time via Hotwire/Turbo Streams without needing a page refresh.

## Key Technologies

- **Ruby on Rails 8**: Core web framework.
- **OpenRouter (`open_router` gem)**: Powers the AI completions backend. Replaced direct OpenAI connections to easily swap or access an array of state-of-the-art LLMs (e.g. `openai/gpt-4o-mini`).
- **Turbo Streams**: Facilitates reactive, real-time UI updates when the lead analysis is complete.
- **Solid Queue**: Rails default database-backed ActiveJob queue for processing the AI queries asynchronously.
- **Bootstrap 5 & Importmaps**: For modern responsive styling without needing complex Javascript bundlers (No Node.js required).

## Setup & Configuration

### Prerequisites
- **Ruby 3.4+**
- **PostgreSQL** or equivalent default DB configured
- OpenRouter API Key

### Installation

1. Clone the repository and install dependencies:
   ```bash
   bundle install
   ```

2. Setup your database:
   ```bash
   rails db:prepare
   ```

### API Keys

You must configure OpenRouter to analyze leads. Set up your OpenRouter API credentials using standard environment variables:

```bash
export OPENROUTER_API_KEY='sk-or-v1-...'
```

*(Alternatively, you can add this securely inside your `credentials.yml.enc` file under `openrouter: api_key`)*

You can optionally configure which model OpenRouter resolves to by setting the `OPENROUTER_MODEL` variable:
```bash
export OPENROUTER_MODEL='openai/gpt-4o-mini'
```

### Running the application

1. Start your background worker and rails server using your preferred process manager (e.g. `bin/dev` or using `foreman` with the Procfile if you have one, or just the unified rails server):
   ```bash
   bin/rails server
   ```
   *(Ensure your background job processor is functioning so that `AnalyzeLeadJob` can execute!)*

2. Open `localhost:3000/leads`
3. Click **"New Lead"** and submit dummy lead information (e.g., "I need urgent digital marketing help!").
4. Watch the list update asynchronously as the lead begins in an *Analyzing...* state, before snapping to the fully analyzed metrics retrieved from the AI model!
