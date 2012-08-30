module RSpec
  module Exegesis
    module DSL
      module Macros
        def the(sym, &block)
          context sym do
            subject { send sym } 
            it &block
          end
        end
      end
    end
  end
end
