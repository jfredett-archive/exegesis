module RSpec
  module Exegesis
    module DSL
      module Macros
        def the(sym, &block)
          context sym do
            subject { if sym.is_a? Class then sym else send sym end } 
            it &block
          end
        end
      end
    end
  end
end
