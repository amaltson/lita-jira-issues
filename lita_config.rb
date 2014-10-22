Lita.configure do |config|
  config.robot.name = 'Jira Lita'
  config.handlers.jira_issues.url = 'http://jira.local'
  config.handlers.jira_issues.username = ENV['JIRA_USER'] || 'user'
  config.handlers.jira_issues.password = ENV['JIRA_PASSWORD'] || 'password'
end
