__END__
module RSpec
  module Exegesis
    module DSL
      module Macros
        def topic(obj, &block)
          if obj 
            __context_stack.reset!
            __context_stack.push_context(obj) do
              describe '' do
                subject { __context_stack.current_subject } 
                block.call
              end
            end
          end
        end

        def consider(sym, &block)
          raise "consider must be nested in a topic block" unless __context_stack_available?

          __context_stack.push_context(sym) do
            context "##{sym}" do
              binding.pry
              subject { __context_stack.current_subject }
              block.call
            end
          end
        end

        def __context_stack
          @@__context_stack ||= ContextStack.new
        end

        def __context_stack_available?
          not (@@__context_stack.nil? || @@__context_stack.empty?)
        end
      end

      require 'forwardable'
      class ContextStack
        extend Forwardable
        def initialize
          reset!
        end

        delegate [:<<, :push, :pop, :empty?] => :@stack

        def push_context(ctx) 
          push(ctx)
          yield
          pop
        end

        def reset!
          @stack = []
        end

        def current_subject
          @stack.drop(1).reduce(send(@stack.first)) do |a,e|
            a = a.send(e)
          end
        end
      end
    end
  end
end

__END__

topic :foo do        | describe :foo do
                     |   subject { send :foo }
                     |   @topic = :foo
                     |
  consider :bar do   |   context "##{:bar}" do
                     |     subject { @topic.send(:bar) }
                     |     @topic = :bar
                     |
    it { ... }       |     it { ... }     
                     | 
  end                |   end
end                  | end

