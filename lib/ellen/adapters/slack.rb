require "zircon"

module Ellen
  module Adapters
    class Slack < Base
      env :SLACK_TEAM, "Account's team name"
      env :SLACK_USERNAME, "Account's username, which must match the name on Slack account"
      env :SLACK_PASSWORD, "Account's IRC password (See https://my.slack.com/account/gateways)"
      env :SLACK_CHANNEL, "Channel name the bot logs in at first"

      # TODO
      def run
      end

      # TODO
      def say(body, options = {})
      end

      private

      def client
        @client ||= Zircon.new(
          channel: channel,
          port: port,
          server: server,
          username: username,
        )
      end

      def channel
        ENV["SLACK_CHANNEL"]
      end

      def port
        "6667"
      end

      def server
        ENV["SLACK_SERVER"]
      end

      def username
        ENV["SLACK_USERNAME"]
      end
    end
  end
end
