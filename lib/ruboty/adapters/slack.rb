require "xrc"

module Ruboty
  module Adapters
    class Slack < Base
      env :SLACK_PASSWORD, "Account's XMPP password (See https://tqhouse.slack.com/account/gateways)"
      env :SLACK_ROOM, "Room name to join in at first (e.g. general)"
      env :SLACK_TEAM, "Account's team name (e.g. wonderland)"
      env :SLACK_USERNAME, "Account's username (e.g. alice)"

      def run
        bind
        connect
      end

      def say(message)
        client.say(
          body: message[:code] ? "```\n#{message[:body]}\n```" : message[:body],
          from: message[:from],
          to: message[:original][:type] == "chat" ? message[:to] + "/resource" : message[:to],
          type: message[:original][:type],
        )
      end

      private

      def client
        @client ||= Xrc::Client.new(
          jid: jid,
          nickname: username,
          password: password,
          room_jid: room_jids.join(","),
        )
      end

      def jid
        "#{username}@#{host}"
      end

      def room_jids
        rooms.map do |room|
          "#{room}@#{room_host}"
        end
      end

      def host
        "#{team}.xmpp.slack.com"
      end

      def room_host
        "conference.#{host}"
      end

      def rooms
        ENV["SLACK_ROOM"].split(",")
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

      def bind
        client.on_private_message(&method(:on_message))
        client.on_room_message(&method(:on_message))
      end

      def connect
        client.connect
      end

      # @note Ignores delayed messages when ruboty was logging out
      def on_message(message)
        unless message.delayed?
          robot.receive(
            body: message.body,
            from: message.from,
            from_name: username_of(message),
            to: message.to,
            type: message.type,
          )
        end
      end

      def username_of(message)
        case message.type
        when "groupchat"
          Xrc::Jid.new(message.from).resource
        else
          Xrc::Jid.new(message.from).node
        end
      end
    end
  end
end
