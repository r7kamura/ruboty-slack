# Ellen::Slack
Slack adapter for [Ellen](https://github.com/r7kamura/ellen).

## Usage
See https://my.slack.com/admin/settings to enable XMPP Gateway on Slack.

```ruby
# Gemfile
gem "ellen-slack"
```

## ENV
```
SLACK_PASSWORD - Account's XMPP password
SLACK_ROOM     - Room name to join in at first (e.g. general)
SLACK_TEAM     - Account's team name (e.g. wonderland)
SLACK_USERNAME - Account's username (e.g. alice)
```
