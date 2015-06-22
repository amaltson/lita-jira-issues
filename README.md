# lita-jira-issues

[![Gem Version](http://img.shields.io/gem/v/lita-jira-issues.svg)](https://rubygems.org/gems/lita-jira-issues)
[![Build Status](http://img.shields.io/travis/amaltson/lita-jira-issues.svg)](https://travis-ci.org/amaltson/lita-jira-issues)
[![Code Climate](http://img.shields.io/codeclimate/github/amaltson/lita-jira-issues.svg)](https://codeclimate.com/github/amaltson/lita-jira-issues)
[![Coverage Status](http://img.shields.io/coveralls/amaltson/lita-jira-issues.svg)](https://coveralls.io/r/amaltson/lita-jira-issues)

Lita handler for showing JIRA issue details when a JIRA issue key is mentioned in
chat. Inspired by the [Hubot jira-issue
plugin](https://github.com/github/hubot-scripts/blob/master/src/scripts/jira-issues.coffee)

**Note**: Version 0.2+ of this hander require Lita 4. If you'd like to use this
handler with Lita 3.x, please use version 0.1

## Installation

Add lita-jira-issues to your Lita instance's Gemfile:

``` ruby
gem "lita-jira-issues"
```


## Configuration

### Base Configuration

The `jira_issues` handler needs to be configured with your JIRA instance. Add
the following configurations to your `lita_config.rb`.

```ruby
config.handlers.jira_issues.url = 'http://jira.local'
config.handlers.jira_issues.username = ENV['JIRA_USER'] || 'user'
config.handlers.jira_issues.password = ENV['JIRA_PASSWORD'] || 'password'
config.handlers.jira_issues.issue_ttl = 0 #optional
config.handlers.jira_issues.format = '[%I] %S::%t'  #optional
```

As in the example above, you can always use environment variables for sensitive
information like the JIRA user's password.

### Ignoring Users

Optionally you can prevent JIRA issue lookups from certain users using the ignore
configuration parameter

```ruby
config.handlers.jira_issues.ignore = [ 'Jira', 'Github' ]
```

### Avoid A Spamming Bot

Optionally you can set a timer for how long to sleep prior to posting an issue to chat again.  This is accomplished by setting an expiring key in Redis. That timeout is governed by the following config

```ruby
config.handlers.jira_issues.issue_ttl = 120
```

The default for this config is 0 which serves to disables the feature entirely.

### Customize Output

You can now change the displayed format using keyword expansion. The following table of keywords can be used to create the response when a JIRA issue is referenced. Each keyword needs to be enclosed in %{} just as the Ruby `%` operator requires.

Each keyword can take one of 3 forms. If the keyword is specified in all CAPS, then the resulting text will be in all caps (i.e. 'KEY' => 'ABC-123'). If the keyword has an initial capital letter, then resulting text will be proper case (i.e. 'Key' => 'Abc-123'). Finally if the keyword is all lower case, then the resulting text will be the native format that the text was received in.

There is also a conditional syntax that can be use should the keyword not return a value. The conditional syntax roughly approximates a ternary operator found in several programming languages such as C, Java and Perl with slight modification to make pattern matching easier.

```
#(%{assignee}?Assigned to %{assignee}|UNASSIGNED)
```

In the above example, the start of the conditional syntax starts with the `#(` and is completed with the closing `)`. The first part (what is preceding the question mark) is what is evaluated. If the evaluation is not an empty string (i.e. ''), then the conditional syntax is replaced with the text between the question and the pipe (`|`) symbol. If the evaluation does return an empty string (i.e. assignee is not set), then the text following the pipe symbol will replace the conditional syntax. As one would expect, keyword substitutions occur within the conditional syntax.

By default the format is set to the original text displayed by the lita-jira-issues module.

```
[%{KEY}] %{summary}
Status: %{status}, #(%{assignee}?assigned to %{assignee}|unassigned), rep. by %{reporter}, fixVersion: #(%{version}?%{version}|NONE)#(%{priority}?, priority: %{priority}|)
%{link}
```

The response to referenced JIRA tickets are left up to you, but shortened formats are now available like:

```
[%{KEY}] %{PRIORITY}/%{Summary} - %{STATUS}\n%{link}
```

Pattern  | Substitution
---------|-------------
key      | Issue number
status   | Issue status
summary  | Issue summary
assignee | Assignee
reporter | Reporter
version  | Version
priority | Priority
link     | URL to JIRA issue page
url      | Same as %{link}

## Usage

Simply mention any JIRA valid key in upper or lower case, eg. JIRA-123, proj-8,
and Lita will respond with the issue details.

## License

[MIT](http://opensource.org/licenses/MIT)
