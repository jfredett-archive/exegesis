# Represents a single node in the AST of a project structure
module AST
  module Node
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)
      base.send(:include, Enumerable)
    end

    module InstanceMethods
      def visit(&block)
        block.call(self)

        children.each do |c|
          c.visit(&block)
        end

        nil
      end

      def run
      end
    end

    module ClassMethods
      def child_node(type)
        define_method(type_to_method_name(type)) do |&block|
          if @children.has_key?(type) and @children[type]
            @children[type].run(&block)
          else
            @children[type] = type.new(&block)
          end
          @children[type]
        end
      end

      private

      def type_to_method_name(type)
        type.to_s.split('::').last.downcase
      end
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

  class Project
    include AST::Node

    attr_reader :name
    attr_reader :children

    def initialize(name, &block)
      @name = name
      @children = {}
      instance_eval &block
    end

    def each(&block)
      children.values.each(&block)
    end

    child_node Structure
    child_node Products
    child_node Dependencies
  end


  def project(name, &block)
    Project.new(name, &block)
  end
end
include AST
