# lita-jira-issues

[![Build Status](http://img.shields.io/travis/amaltson/lita-jira-issues.svg)](https://travis-ci.org/amaltson/lita-jira-issues)
[![Code Climate](http://img.shields.io/codeclimate/github/amaltson/lita-jira-issues.svg)](https://codeclimate.com/github/amaltson/lita-jira-issues)
[![Coverage Status](http://img.shields.io/coveralls/amaltson/lita-jira-issues.svg)](https://coveralls.io/r/amaltson/lita-jira-issues)

Lita handler for showing JIRA issue details when a JIRA issue key is mentioned in
chat. Inspired by the [Hubot jira-issue
plugin](https://github.com/github/hubot-scripts/blob/master/src/scripts/jira-issues.coffee)

## Installation

Add lita-jira-issues to your Lita instance's Gemfile:

``` ruby
gem "lita-jira-issues"
```


## Configuration

The `jira_issues` handler needs to be configured with your JIRA instance. Add
the following configurations to your `lita_config.rb`.

```ruby
config.handlers.jira_issues.url = 'http://jira.local'
config.handlers.jira_issues.username = ENV['JIRA_USER'] || 'user'
config.handlers.jira_issues.password = ENV['JIRA_PASSWORD'] || 'password'
```

As in the example above, you can always use environment variables for sensitive
information like the JIRA user's password.

## Usage

Simply mention any JIRA valid key in upper or lower case, eg. JIRA-123, proj-8,
and Lita will respond with the issue details.

## License

[MIT](http://opensource.org/licenses/MIT)
