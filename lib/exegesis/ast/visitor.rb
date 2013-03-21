module Exegesis
  module AST
    class Visitor
      def before_visit!(node)
        #intentionally blank - implement in subclass
      end

      def after_visit!(node)
        #intentionally blank - implement in subclass
      end

      def call(node)
        return send(node.method_name, node) if respond_to?(node.method_name)
        unknown(node)
      end
    end
  end
end
