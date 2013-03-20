# A collection of shared methods for Directories and SourceFiles
module Exegesis
  module FileSystemEntity
    def self.included(base)
      base.send(:include , Registerable)
      base.send(:extend  , Forwardable)
      base.send(:include , Methods)
    end

    module Methods
      def path
        File.join(parent.path, name)
      end

      def inspect
        "#{self.class.inspect}(#{path.inspect})"
      end

      attr_reader :parent, :name
      alias container parent

      def basename
        File.basename(name, ext)
      end

      def ext
        @ext || ""
      end
      alias extension ext

      def visit(visitor)
        visitor.on_enter if visitor.respond_to? :on_enter

        visitor.call(self.class, self)

        if respond_to?(:directories)
          directories.each do |dir|
            dir.visit(visitor)
          end
        end

        if respond_to?(:files)
          files.each do |file|
            file.visit(visitor)
          end
        end

        visitor.on_exit if visitor.respond_to? :on_exit
      end
    end
  end
end
