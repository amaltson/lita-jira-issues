require "spec_helper"

describe Lita::Handlers::JiraIssues, lita_handler: true do

  it 'should fail to start without configuration' do
    send_message('Trying to use JIRA_123 not configured')
  end

  it { routes('JIRA-123').to(:jira_message) }
  it { routes('user talking about something JIRA-123 had key').to(:jira_message) }

  describe 'Looking up keys' do

    before(:each) do
      Lita.config.handlers.jira_issues.url = 'http://jira.local'
      Lita.config.handlers.jira_issues.username = 'user'
      Lita.config.handlers.jira_issues.password = 'pass'
    end

    it 'should reply with JIRA description if one seen' do
      allow_any_instance_of(JiraGateway).to receive(:data_for_issue)
        .and_return(
      {
        key:'KEY-424',
        fields: {
          summary: 'Another issue'
        }
      })
      send_message('Some message KEY-424 more text')
      expect(replies.last).to eq('[KEY-424] Another issue')
    end

    it 'it should reply with multiple JIRA descriptions if many seen' do
      allow_any_instance_of(JiraGateway).to receive(:data_for_issue)
        .and_return(
      {key:'PROJ-9872', fields: { summary: 'Too many bugs'}},
      {key:'NEW-1', fields: { summary: 'New 1'}})
      send_message('Some PROJ-9872 message NEW-1 more text')
      expect(replies.pop).to eq('[NEW-1] New 1')
      expect(replies.pop).to eq('[PROJ-9872] Too many bugs')
    end

  end

end
