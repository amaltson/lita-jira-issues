require "spec_helper"

describe Lita::Handlers::JiraIssues, lita_handler: true do

  it { is_expected.to route('JIRA-123').to(:jira_message) }
  it { is_expected.to route('user talking about something JIRA-123 had key').to(:jira_message) }

  describe 'Looking up keys' do

    context 'Test silenced handler' do

      let(:redis) { Redis::Namespace }

      it 'should return false when issue ttl is set to 0, which is default' do
        Lita.config.handlers.jira_issues.issue_ttl = 0
        expect(Lita::Handlers::JiraIssues.new.silenced?("KEY-123")).to eql false
      end

      context 'configured ttl of 10 seconds' do
        before(:each) { Lita.config.handlers.jira_issues.issue_ttl = 10 }

        it 'should return true with redis ttl is 10' do
          allow_any_instance_of(redis).to receive(:ttl).with('KEY-424').and_return("10")
          expect(Lita::Handlers::JiraIssues.new.silenced?("KEY-424")).to eql true
        end

        it 'should return true for silenced when redis ttl is -2' do
          allow_any_instance_of(redis).to receive(:ttl).with('KEY-424').and_return("-2")
          expect(Lita::Handlers::JiraIssues.new.silenced?("KEY-424")).to eql false
        end
      end

    end

    before(:each) do
      Lita.test_mode = true
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
          fixVersions: [ { name: 'Sprint 2' } ],
          priority: { name: 'Undecided' }
        }
      })
      send_message('Some message KEY-424 more text')
      expect(replies.last).to eq(<<-EOS.chomp
[KEY-424] Another issue
Status: Fixed, assigned to User, rep. by Reporter, fixVersion: Sprint 2, priority: Undecided
http://jira.local/browse/KEY-424
                                 EOS
                                )
    end

    it 'it should reply with multiple JIRA descriptions if many seen' do
      mock_multiple_jiras
      send_message('Some PROJ-9872 message nEw-1 more text')
      expect(replies.pop).to eq(<<-EOS.chomp
[NEW-1] New 1
Status: Open, unassigned, rep. by User2, fixVersion: NONE, priority: High
http://jira.local/browse/NEW-1
                                EOS
                               )
      expect(replies.pop).to eq(<<-EOS.chomp
[PROJ-9872] Too many bugs
Status: Resolved, unassigned, rep. by User, fixVersion: NONE
http://jira.local/browse/PROJ-9872
                                EOS
                               )
    end

    it 'it should reply once for each seen JIRA issue' do
      mock_multiple_jiras
      send_message(
        'Some PROJ-9872 message nEw-1 more text with PROJ-9872 mentioned')
      expect(replies.size).to eq(2)
      expect(replies.pop).to include('[NEW-1] New 1')
      expect(replies.pop).to include('[PROJ-9872] Too many bugs')
    end

    it 'should handle ignoring users' do
      Lita.config.handlers.jira_issues.ignore = ['Bob Smith']

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
          fixVersions: [ { name: 'Sprint 2' } ],
          priority: { name: 'Undecided' }
        }
      })

      bob = Lita::User.create(123, name: "Bob Smith")
      fred = Lita::User.create(123, name: "Fred Smith")

      send_message('Some message KEY-424 more text', as: bob)
      expect(replies.last).not_to match('KEY-424')
      send_message('Some message KEY-424 more text', as: fred)
      expect(replies.last).to match('KEY-424')
    end

    def mock_jira(key, result)
      allow_any_instance_of(JiraGateway).to receive(:data_for_issue)
        .with(key)
        .and_return(result)
    end

    def mock_multiple_jiras
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
                  fixVersions: [],
                  priority: { name: 'High' }
                }})
    end

  end

end
