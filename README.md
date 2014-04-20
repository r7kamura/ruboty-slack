# Ellen::Slack
Slack adapter for [Ellen](https://github.com/r7kamura/ellen).

## Usage
Note that you must enable the IRC gateway at https://my.slack.com/admin/settings.

```
# Gemfile
gem "ellen-slack"
```

## ENV
```
SLACK_TEAM - Account's team name
SLACK_USER - Account's username, which must match the name on Slack account
SLACK_PASS - Account's IRC password (See https://my.slack.com/account/gateways)
```
