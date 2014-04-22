require "zircon"
require "yaml"

module Ellen
  module Adapters
    class Slack < Base
      INTERVAL = 0.1

      env :SLACK_CHANNEL, "Channel name the bot logs in at first"
      env :SLACK_PASSWORD, "Account's IRC password (See https://my.slack.com/account/gateways)"
      env :SLACK_TEAM, "Account's team name"
      env :SLACK_USERNAME, "Account's username, which must match the name on Slack account"
      env :SLACK_NO_SSL, "Pass 1 if you don't want to use SSL connection", optional: true

      def run
        bind
        connect
      end

      def say(body, options = {})
        body.split("\n").each do |line|
          client.privmsg(channel, ":#{line}")
          wait
        end
      end

      private

      def client
        @client ||= Zircon.new(
          channel: channel,
          password: password,
          port: port,
          server: server,
          username: username,
          use_ssl: ssl,
        )
      end

      def channel
        ENV["SLACK_CHANNEL"]
      end

      def port
        "6667"
      end

      def server
        "#{team}.irc.slack.com"
      end

      def username
        ENV["SLACK_USERNAME"]
      end

      def password
        ENV["SLACK_PASSWORD"]
      end

      def team
        ENV["SLACK_TEAM"]
      end

      def ssl
        !ENV["SLACK_NO_SSL"]
      end

      def bind
        client.on_privmsg do |message|
          body = message.body.force_encoding("UTF-8")
          robot.receive(body: body)
        end
      end

      def connect
        client.run!
      end

      # Wait for Slack IRC Gateway to process message queue.
      # If we send 2 messages in too short time,
      # sometimes the slack double-renders the first message by mistake.
      def wait
        sleep(INTERVAL)
      end
    end
  end
end
