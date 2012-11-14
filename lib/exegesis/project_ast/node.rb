# Represents a single node in the AST of a project structure
module AST
  module Node
    def visit(&block)
      block.call(self)

      children.each do |c|
        c.visit(&block)
      end

      nil
    end
  end

  class Project
    include Node

    attr_reader :name
    attr_reader :children

    def initialize(name, &block)
      @name = name
      @children = []
      instance_eval &block
    end

    def structure(&block)
      children << Structure.new(&block)
    end

    def products(&block)
      children << Products.new(&block)
    end

    def dependencies(&block)
      children << Dependencies.new(&block)
    end
  end

  class Structure
    include Node
  end
  class Products
    include Node
  end
  class Dependencies
    include Node
  end

  def project(name, &block) 
    Project.new(name, &block)
  end
end
include AST
