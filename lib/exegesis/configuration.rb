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
      @validation ||= AST::Validator.new.tap do |validator|
        project_ast.visit(validator)
      end
    end
    alias validation validate!

    private

    attr_reader :project_ast
  end
end
