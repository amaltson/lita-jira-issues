require_relative 'jira_gateway'

module Lita
  module Handlers
    class JiraIssues < Handler

      def initialize(*args)
        super(args)
        @jira = JiraGateway.new(http, config)
      end

      def self.default_config(config)
        config.enabled = true
      end

      route /[a-zA-Z]+-\d+/, :jira_message, help: {
        "KEY-123" => "Replies with information about the given JIRA key"
      }

      def jira_message(response)
        unless configured?
          raise 'Need to configure url, username, password for jira_issues ' \
            'to work'
        end
        response.matches.each do | key |
          handle_key(response, key)
        end
      end

      def configured?
        config.url && config.username && config.password
      end

      def handle_key(response, key)
        data = @jira.data_for_issue(key)
        return if data.empty?
        issue = issue_details(data)
        response.reply issue
      end

      def issue_details(data)
        key = data[:key]
        data = data[:fields]
        issue = "[#{key}] #{data[:summary]}"
        issue << "\nStatus: #{data[:status][:name]}"
        issue << assignee(data)
        issue << reporter(data)
        issue << fix_version(data)
        issue << priority(data)
        issue << issue_link(key)
      end

      def assignee(data)
        if assigned_to = data[:assignee]
          return ", assigned to #{assigned_to[:displayName]}"
        end
        ', unassigned'
      end

      def reporter(data)
        ", rep. by #{data[:reporter][:displayName]}"
      end

      def fix_version(data)
        fix_versions = data[:fixVersions]
        if fix_versions and fix_versions.first
          ", fixVersion: #{fix_versions.first[:name]}"
        else
          ', fixVersion: NONE'
        end
      end

      def priority(data)
        if data[:priority]
          ", priority: #{data[:priority][:name]}" 
        else
          ""
        end
      end

      def issue_link(key)
        "\n#{config.url}/browse/#{key}"
      end
    end

    Lita.register_handler(JiraIssues)
  end
end
