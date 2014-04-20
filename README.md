# Ellen::Slack
Slack adapter for [Ellen](https://github.com/r7kamura/ellen).

## Usage
Note that you must enable the IRC gateway at https://my.slack.com/admin/settings.

```ruby
# Gemfile
gem "ellen-slack"
```

## ENV
```
SLACK_CHANNEL  - Channel name the bot logs in at first
SLACK_PASSWORD - Account's IRC password (See https://my.slack.com/account/gateways)
SLACK_TEAM     - Account's team name
SLACK_USERNAME - Account's username, which must match the name on Slack account
SLACK_NO_SSL   - Pass 1 if you don't want to use SSL connection
```
