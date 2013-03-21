module Exegesis
  module AST
    class Structure
      include Node

      terminal Src
      terminal Obj
      terminal Test
      terminal Bin

      multiple SourceFile

      terminal License

      nonterminal Directory

    end
  end
end
