# Clear existing database entries to ensure a clean slate
Lead.destroy_all

# High intent lead - completed qualification
Lead.create!(
  name: "Sarah Jenkins",
  email: "sarah.jenkins@enterprise-corp.com",
  message: "Hi, we are currently migrating our legacy infrastructure to AWS and need a secure API gateway partner. We have a budget of $50k/year allocated for this and want to start a POC by next Monday. Please have an enterprise architect call me ASAP at 555-0199.",
  ai_status: :completed,
  summary: "Enterprise customer migrating legacy infrastructure to AWS. Needs a secure API gateway. Active budget of $50k/yr, urgent POC start by next Monday, requested phone call from an enterprise architect ASAP.",
  intent: "hot",
  urgency: "High",
  lead_score: 9
)

# Medium intent lead - completed qualification
Lead.create!(
  name: "Alex Rivera",
  email: "alex.rivera@startup-labs.io",
  message: "Just checking out your pricing. Do you support custom domains on the free tier, or do we need to upgrade to the team plan immediately?",
  ai_status: :completed,
  summary: "Inquiring about pricing and feature availability (custom domains) on the free tier versus team plan upgrade options.",
  intent: "warm",
  urgency: "Medium",
  lead_score: 6
)

# Low intent lead - completed qualification
Lead.create!(
  name: "John Doe",
  email: "john.doe@gmail.com",
  message: "Do you have any job openings for junior developers? Thanks.",
  ai_status: :completed,
  summary: "General recruitment/career query regarding junior developer roles.",
  intent: "cold",
  urgency: "Low",
  lead_score: 1
)

# Unprocessed lead - pending analysis state
Lead.create!(
  name: "David Chen",
  email: "d.chen@globaltech.com",
  message: "Looking for customized integration support for a enterprise CRM deployment. Please contact sales to schedule an introductory call.",
  ai_status: :pending
)
