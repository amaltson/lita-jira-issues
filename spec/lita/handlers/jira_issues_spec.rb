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
      mock_jira('KEY-424', {
        key:'KEY-424',
        fields: {
          summary: 'Another issue',
          status: {
            name: 'Fixed'
          },
          assignee: {
            displayName: 'User'
          },
          reporter: {
            displayName: 'Reporter'
          },
          fixVersions: [ { name: 'Sprint 2' } ]
        }
      })
      send_message('Some message KEY-424 more text')
      expect(replies.last).to eq(<<-EOS.chomp
[KEY-424] Another issue
Status: Fixed, assigned to User, rep. by Reporter, fixVersion: Sprint 2
                                 EOS
                                )
    end

    it 'it should reply with multiple JIRA descriptions if many seen' do
      mock_jira('PROJ-9872',
                {key:'PROJ-9872',
                 fields: {
                  summary: 'Too many bugs',
                  status: {
                    name: 'Resolved'
                  },
                  assignee: nil,
                  reporter: {
                    displayName: 'User'
                  }
                }})
      mock_jira('nEw-1',
                {key:'NEW-1',
                 fields: {
                  summary: 'New 1',
                  status: {
                    name: 'Open'
                  },
                  reporter: {
                    displayName: 'User2'
                  },
                  fixVersions: []
                }})

      send_message('Some PROJ-9872 message nEw-1 more text')
      expect(replies.pop).to eq(<<-EOS.chomp
[NEW-1] New 1
Status: Open, unassigned, rep. by User2, fixVersion: NONE
                                EOS
                               )
      expect(replies.pop).to eq(<<-EOS.chomp
[PROJ-9872] Too many bugs
Status: Resolved, unassigned, rep. by User, fixVersion: NONE
                                EOS
                               )
    end

    def mock_jira(key, result)
      allow_any_instance_of(JiraGateway).to receive(:data_for_issue)
        .with(key)
        .and_return(result)
    end

  end

end
