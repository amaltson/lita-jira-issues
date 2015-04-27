require_relative 'jira_gateway'
require 'set'

module Lita
  module Handlers
    class JiraIssues < Handler

      config :url, required: true, type: String
      config :username, required: true, type: String
      config :password, required: true, type: String
      config :ignore, default: [], type: Array
      config :key_expiration, default: 120, type: Integer

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
        unless config.key_expiration == 0
          current_ttl = redis.ttl(key).to_i
          if current_ttl > 0
            log.debug("Key expiration not met for #{key}, will not reprompt for #{current_ttl} seconds")
            return
          else
            redis.setex(key, config.key_expiration, key)
            log.debug("Setting expiring key in redis for JIRA issue: #{key}. Key is configured to expire in #{config.key_expiration} seconds")
          end
        end
        issue = issue_details(data)
        response.reply issue
      end

      def issue_details(data)
        key = data[:key]
        data = data[:fields]
        issue = summary(key, data)
        issue << status(data)
        issue << assignee(data)
        issue << reporter(data)
        issue << fix_version(data)
        issue << priority(data)
        issue << issue_link(key)
      end

      def summary(key, data)
        "[#{key}] #{data[:summary]}"
      end

      def status(data)
        "\nStatus: #{data[:status][:name]}"
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
