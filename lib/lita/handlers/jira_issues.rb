module Lita
  module Handlers
    class JiraIssues < Handler

      def self.default_config(config)
        config.enabled = true
      end

      route /[A-Z]+-\d+/, :jira_message, help: {
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
        response.reply "[#{key}]"
      end

    end

    Lita.register_handler(JiraIssues)
  end
end
