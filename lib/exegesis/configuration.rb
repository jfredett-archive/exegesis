module Exegesis
  class Project
    def initialize(project_ast)
      @project_ast = project_ast
    end

    def valid?
      validation.result
    end

    def invalid?
      not valid?
    end

    def errors
      validation.errors
    end

    def validate!
      @validation ||= ASTValidator.new.tap do |validator|
        project_ast.visit(validator)
      end
    end
    alias validation validate!

    private

    attr_reader :project_ast

    class ASTValidator < AST::Visitor
      attr_reader :errors

      def initialize
        @errors = Errors.new
      end

      def project(node)
        error(:project, "must provide a name") unless node.name
      end

      def structure(node)
        error(:structure, "already specified structure node") if @seen_structure
        @seen_structure = true
      end

      def src(node)
      end

      def obj(node)
      end

      def test(node)
      end

      def bin(node)
      end

      def file(node)
      end

      def directory(node)
      end

      def license(node)
      end

      def products(node)
      end

      def binary(node)
      end

      def lib(node)
      end

      def compiler(node)
      end

      def package(node)
      end

      def dependencies(node)
      end

      def unknown(node)
      end

      def result
        errors.empty?
      end

      private

      def error(attr, value)
        errors << Error.new(attr, value, nil, nil)
      end

      class Error
        attr_reader :attr, :message
        alias key attr
        def initialize(attr, message, file = nil, line = nil)
          @attr = attr
          @message = message
        end
      end

      class Errors < Array
        def has_key?(k)
          !!detect { |e| e.key == k }
        end
      end
    end
  end
end
