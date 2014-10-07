require "spec_helper"

describe Lita::Handlers::JiraIssues, lita_handler: true do
  it { routes('JIRA-123').to(:jira_key) }
  it { routes('user talking about something JIRA-123 had key').to(:jira_key) }
end
