# Represents a single node in the AST of a project structure
module AST
  module Node
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.send(:extend, ClassMethods)
      base.send(:include, Enumerable)
    end

    class ObjectSet < Array
      def visit(visitor)
        each do |c|
          c.visit(visitor)
        end
      end
    end

    class Visitor
      def before_visit!
        #intentionally blank - implement in subclass
      end

      def after_visit!
        #intentionally blank - implement in subclass
      end

      def call
        raise "Abstract: Implement in subclass"
      end
    end

    module InstanceMethods
      def visit(visitor)
        visitor.before_visit!
        visitor.call(self)

        each do |c|
          c.visit(visitor)
        end

        visitor.after_visit!
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

      def name
        @name || self.class.name
      end

      def initialize(name = nil, opts = {}, &block)
        @name = name
        @opts = opts
        instance_eval &block if block_given?
      end

      def terminal?
        self.class.terminal?
      end
    end

    module ClassMethods
      def nonterminal(type)
        raise "NonterminalInTerminalError" if terminal? && binding.pry
        define_method(type_to_method_name(type)) do |name=nil, opts={}, &block|
          if children.has_key?(type) and children[type]
            children[type].run(&block)
          else
            children[type] = type.new(name, opts={}, &block)
          end
          children[type]
        end
      end

      def terminal(type)
        #should only allow one.
        raise "InvalidNodeTypeError" unless type.terminal? || binding.pry
        define_method(type_to_method_name(type)) do |name=nil, opts={}, &block|
          raise "TerminalAlreadySetError" if children.has_key?(type)
          children[type] = type.new(name, opts, &block)
        end
      end
      def terminal!
        define_singleton_method(:terminal?) { true }
      end
      def terminal?; false end

      def multiple(type)
        #should store an entry in #children that is a list of all the instances
        #it sees of this type. eg, `file 'x'; file 'y' #=> children[File] = [File<@name=x>, File<@name=y>]
        raise "InvalidNodeTypeError" unless type.terminal? || binding.pry
        define_method(type_to_method_name(type)) do |name, opts={}, &block|
          children[type] ||= ObjectSet.new
          children[type] << type.new(name, opts, &block)
        end
      end

      private

      def type_to_method_name(type)
        if type.respond_to?(:name)
          type.name
        else
          type.to_s
        end.split('::').last.downcase
      end
    end
  end

  class SourceFile
    include Node
    terminal!

    def self.name
      "File"
    end
  end

  class Src
    include Node
    terminal!
  end

  class Obj
    include Node
    terminal!
  end

  class Bin
    include Node
    terminal!
  end

  class Test
    include Node
    terminal!
  end

  class Deps
    include Node
    terminal!

    def self.name
      'Dependencies'
    end
  end

  class License
    include Node
    terminal!
  end

  class Directory
    include Node

    nonterminal Directory
    multiple SourceFile
  end

  class Binary
    include Node
    terminal!

    terminal Deps
  end

  class Lib
    include Node
    terminal!

    terminal Deps
  end

  class Compiler
    include Node
    terminal!
  end

  class Package
    include Node
    terminal!
  end

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

  class Products
    include Node

    nonterminal Binary
    nonterminal Lib
  end

  class Dependencies
    include Node

    multiple Compiler
    multiple Package
  end

  class Project
    include Node

    nonterminal Structure
    nonterminal Products
    nonterminal Dependencies
  end

  def project(name, opts={}, &block)
    Project.new(name, opts, &block)
  end
end

include AST
