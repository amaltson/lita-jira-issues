module Lita
  module Handlers
    class JiraIssues < Handler
      route /[A-Z]+-\d+/, :jira_key, help: {
        "KEY-123" => "Replies with information about the given JIRA key"
      }
    end

    Lita.register_handler(JiraIssues)
  end
end
