module Registerable
  def self.included(base)
    base.instance_eval do
      extend  ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods
    def create(parent, name, searcher = FileSearcher)
      path = File.join(parent.path, name)
      if registry.has_key?(path)
        registry[path]
      else
        new(parent, name, searcher).tap do |instance|
          registry.register! instance
        end
      end
    end

    def registry
      @flyweight ||= Flyweight.new do |dir|
        if dir.respond_to? :path
          dir.path
        else
          dir
        end
      end
    end
  end

  module InstanceMethods
    def path
      build_path(parent, name)
    end

    private

    def build_path(parent, child)
      self.class.build_path(parent, child)
    end
  end
end
