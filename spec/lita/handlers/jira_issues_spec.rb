require "spec_helper"

describe Lita::Handlers::JiraIssues, lita_handler: true do
  it { routes('JIRA-123').to(:jira_key) }
  it { routes('user talking about something JIRA-123 had key').to(:jira_key) }

  it 'should reply with JIRA description if one seen' do
    send_message('Some message KEY-424 more text')
    expect(replies.last).to eq('[KEY-424]')
  end

  it 'it should reply with multiple JIRA descriptions if many seen' do
    send_message('Some PROJ-9872 message NEW-1 more text')
    expect(replies.pop).to eq('[NEW-1]')
    expect(replies.pop).to eq('[PROJ-9872]')
  end

end
