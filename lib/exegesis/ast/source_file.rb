module Exegesis
  module AST
    class SourceFile
      include Node
      terminal!

      def self.name
        "File"
      end
    end
  end
end

