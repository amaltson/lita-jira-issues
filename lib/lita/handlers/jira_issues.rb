require_relative 'jira_gateway'
require 'set'

module Lita
  module Handlers
    class JiraIssues < Handler

      config :url, required: true, type: String
      config :username, required: true, type: String
      config :password, required: true, type: String
      config :ignore, default: [], type: Array
      config :issue_ttl, default: 0, type: Integer
      config :format, default: "[%I] %t\nStatus: %s, assigned to %a, rep. by %r, fixVersion: %v, priority: %P\n%U", type: String
      

      route /[a-zA-Z]+-\d+/, :jira_message, help: {
        "KEY-123" => "Replies with information about the given JIRA key"
      }

      def jira_message(response)
        return if config.ignore.include?(response.user.name)
        @jira ||= JiraGateway.new(http, config)
        Set.new(response.matches).each do | key |
          handle_key(response, key)
        end
      end

      def handle_key(response, key)
        data = @jira.data_for_issue(key)
        return if data.empty?
        return if silenced?(key)
        issue = issue_details(data)
        response.reply issue
      end

      def issue_details(data)
        key = data[:key]
        data = data[:fields]
        
        # build out the response from the configured format
        text = String.new(config.format)
        text.sub!('%I', key.upcase)
        text.sub!('%i', key.downcase)
        text.sub!('%S', status(data).upcase)
        text.sub!('%s', status(data))
        text.sub!('%t', summary(data))
        text.sub!('%a', assignee(data))
        text.sub!('%r', reporter(data))
        text.sub!('%v', fix_version(data))
        text.sub!('%P', priority(data).upcase)
        text.sub!('%p', priority(data).downcase)
        text.sub!('%U', issue_link(key))
        
        return text
      end

      def status(data)
        data[:status][:name]
      end

      def summary(data)
        data[:summary]
      end
      
      def assignee(data)
        if assigned_to = data[:assignee]
          return assigned_to[:displayName]
        end
        'unassigned'
      end

      def reporter(data)
        data[:reporter][:displayName]
      end

      def fix_version(data)
        fix_versions = data[:fixVersions]
        if fix_versions and fix_versions.first
          fix_versions.first[:name]
        else
          'NONE'
        end
      end

      def priority(data)
        if data[:priority]
          data[:priority][:name]
        else
          ""
        end
      end

      def issue_link(key)
        "#{config.url}/browse/#{key}"
      end

      def silenced?(key)

        if config.issue_ttl == 0
          log.debug("JiraIssues: issue_ttl is set to 0, will post every matched issue to chat")
          return false
        end

        current_ttl = redis.ttl(key).to_i

        if current_ttl > 0
          log.debug("JiraIssues: Key expiration not met for #{key}, will not reprompt for #{current_ttl} seconds")
          true
        else
          redis.setex(key, config.issue_ttl, key)
          log.debug("JiraIssues: Setting expiring key in redis for JIRA issue: #{key}. Key is configured to expire in #{config.issue_ttl} seconds")
          false
        end
      end

    end

    Lita.register_handler(JiraIssues)
  end
end
