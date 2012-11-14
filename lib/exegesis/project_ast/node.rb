# Represents a single node in the AST of a project structure
module AST
  module Node
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.send(:extend, ClassMethods)
      base.send(:include, Enumerable)
    end

    module InstanceMethods
      def visit(&block)
        block.call(self)

        each do |c|
          c.visit(&block)
        end

        nil
      end

      def run
      end

      def each(&block)
        children.values.each(&block)
      end

      def children
        @children ||= {}
      end
    end

    module ClassMethods
      def nonterminal(type)
        define_method(type_to_method_name(type)) do |&block|
          if children.has_key?(type) and children[type]
            children[type].run(&block)
          else
            children[type] = type.new(&block)
          end
          children[type]
        end
      end

      def terminal(type)
        #should only allow one.
      end

      def multiple(type)
        #should store an entry in #children that is a list of all the instances
        #it sees of this type. eg, `file 'x'; file 'y' #=> children[File] = [File<@name=x>, File<@name=y>]
        #NOTE: Maybe define a <Object>List node with these nested underneath it?
      end

      private

      def type_to_method_name(type)
        type.to_s.split('::').last.downcase
      end
    end
  end

  class Directory
    include Node
  end

  class Binary
    include Node
  end

  class Lib
    include Node
  end

  class Compiler
    include Node
  end

  class Package
    include Node
  end

  class Structure
    include Node

    terminal :src
    terminal :obj
    terminal :test
    terminal :bin

    multiple File

    terminal :license

    nonterminal Directory
  end

  class Products
    include Node

    nonterminal Binary
    nonterminal Lib
  end

  class Dependencies
    include Node

    nonterminal Compiler
    nonterminal Package #this is a bit of a weird nonterminal -- the block is important, but not for more specification, this may need to be changed
  end

  class Project
    include AST::Node

    attr_reader :name
    def initialize(name, &block)
      @name = name
      instance_eval &block
    end

    nonterminal Structure
    nonterminal Products
    nonterminal Dependencies
  end


  def project(name, &block)
    Project.new(name, &block)
  end
end
include AST
