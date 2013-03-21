module Exegesis
  module AST
    class Deps
      include Node
      terminal!

      def self.name
        'Dependencies'
      end
    end
  end
end
