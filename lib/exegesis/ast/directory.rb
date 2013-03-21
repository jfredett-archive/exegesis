module Exegesis
  module AST
    class Directory
      include Node

      nonterminal Directory
      multiple SourceFile
    end
  end
end

