require 'rspec/expectations' 

require 'pry'

module RSpec
  module Exegesis
    module DSL
      module Matchers
        class DelegateMatcher
          def initialize(message_to_receive)
            @message_to_receive = message_to_receive
          end

          def to(target)
            @target_object = target
            self
          end

          def when_calling(messag)
            @message_to_send
            self
          end

          def matches?(target)
            target_object.should_receive(message_to_receive)
            target.send(message_to_send)
            true
          end

          def failure_message_for_should
            "expected to receive ##{message_to_receive} on #{target_object} when sending ##{message_to_send}, but didn't"
          end

          private 
          attr_reader :message_to_receive, :target_object

          # default to delegating the message directly
          def message_to_send
            @message_to_send || @message_to_receive 
          end
        end

        def delegate(message)
          DelegateMatcher.new(message)
        end
      end

    end
  end
end
