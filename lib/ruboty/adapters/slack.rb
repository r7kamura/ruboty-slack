require "slack"
require "mem"

module Ruboty
  module Adapters
    class Slack < Base
      env :SLACK_API_TOKEN, "Account's API token (See https://api.slack.com/web#basics)"

      include Mem

      def run
        Ruboty.logger.debug("#{self.class}##{__method__} started")
        init
        bind
        connect
        Ruboty.logger.debug("#{self.class}##{__method__} finished")
      end

      def say(message)
        response = client.chat_postMessage(
          channel: message[:original][:channel],
          text: message[:code] ? "```\n#{message[:body]}\n```" : message[:body],
          username: username,
          as_user: true
        )
        Ruboty.logger.debug("error: #{response["error"]}") unless response["ok"]
      end

      private

      def init
        ENV["RUBOTY_NAME"] ||= username
      end

      def username
        client.auth_test["user"]
      end
      memoize :username

      def bind
        stream.on :message do |message|
          on_message(message)
        end
      end

      def connect
        stream.start
      end

      def on_message(message)
        Ruboty.logger.debug("#{message}")
        robot.receive(
          body: expand_message(message),
          from: message["user"],
          from_name: username_of(message),
          channel: message["channel"],
        )
      end

      def expand_message(message)
        text = message["text"]
        regex = /<(@(?<user_id>\w+))>/i
        match = regex.match(text)
        return text unless match
        user_name = user_info(id: match[:user_id])["name"]
        text.gsub(regex) {|w| "@#{user_name}" }
      end

      def username_of(message)
        users.select{|user|  user["id"] == message["user"] }.first
      end

      def stream
        ::Slack::RealTime::Client.new(client.post("rtm.start")["url"])
      end
      memoize :stream

      # Web API

      def client
        ::Slack::Client.new(token: ENV["SLACK_API_TOKEN"])
      end
      memoize :client

      def users
        client.users_list["members"]
      end
      memoize :users

      def user_info(args)
        users.select {|member|
          args.keys.inject(true) {|m, i| m and member[i.to_s] == args[i] }
        }.first
      end
    end
  end
end
